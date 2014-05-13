require 'spec_helper'

describe RetrievalLite::BooleanRetrieval do
  let (:document) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_replicated) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_one_term) do
    RetrievalLite::Document.new("lorem")
  end
  let (:document_with_duplicates) do
    RetrievalLite::Document.new("lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet")
  end
  let (:document_strange) do
    RetrievalLite::Document.new("foo bar")
  end
  let (:all_documents) do
    [document, document_replicated, document_with_duplicates, document_one_term, document_strange]
  end
  let (:corpus) do
    RetrievalLite::Corpus.new(all_documents)
  end

  describe "#has_boolean_operators?" do
    it "should accept any uses of AND OR NOT" do
      RetrievalLite::BooleanRetrieval.has_boolean_operators?("foo AND bar").should == true
      RetrievalLite::BooleanRetrieval.has_boolean_operators?("foo OR bar").should == true
      RetrievalLite::BooleanRetrieval.has_boolean_operators?("foo NOT bar").should == true
    end
    it "should reject any regular non-boolean queries" do
      RetrievalLite::BooleanRetrieval.has_boolean_operators?("foo bar").should == false
    end
  end

  describe "#is_valid_expression?" do
    it "should accept parenthesis and spaces, as well as all alphanumeric characters" do
      RetrievalLite::BooleanRetrieval.is_valid_expression?("(foo AND bar) OR baz").should == true
    end
    it "should reject when there is a close parethensis but no term after AND/OR/NOT" do
      RetrievalLite::BooleanRetrieval.is_valid_expression?("(foo AND bar AND)").should == false
      RetrievalLite::BooleanRetrieval.is_valid_expression?("(foo AND bar AND )").should == false
    end
    it "should accept AND/OR/NOT with any begin parenthesis after it, regardless if there's a whitespace" do
      RetrievalLite::BooleanRetrieval.is_valid_expression?("NOT(foo AND bar)").should == true
      RetrievalLite::BooleanRetrieval.is_valid_expression?("NOT (foo AND bar)").should == true
    end
    it "should accept sentences" do
      RetrievalLite::BooleanRetrieval.is_valid_expression?("foo bar.").should == true
    end
  end

  describe "#strip_query" do
    it "should strip any commas, periods, etc nonalphanumeric characters" do
      RetrievalLite::BooleanRetrieval.strip_query("(This is a cat.) AND (Although, something else!)").should == "(This is a cat ) AND (Although  something else )"
    end
    it "should strip any double, triple, etc hyphenated words" do
      RetrievalLite::BooleanRetrieval.strip_query("This is it--hooray!").should == "This is it hooray "
    end
    it "should leave hyphenated words alone" do
      RetrievalLite::BooleanRetrieval.strip_query("This is foo-bar").should == "This is foo-bar"
    end
    it "should remove lone hyphens" do
      RetrievalLite::BooleanRetrieval.strip_query("This - is foo-bar").should == "This is foo-bar"
    end
  end

  describe "invalid boolean" do
    it "should error on unclosed parenthesis" do
      expect { RetrievalLite::BooleanRetrieval.evaluate(corpus, "(lorem AND ipsum") }.to raise_error
    end
    it "should error on when not enough arguments are provided" do
      expect { RetrievalLite::BooleanRetrieval.evaluate(corpus, "lorem AND ipsum OR") }.to raise_error
    end
  end

  describe "one-term retrieval" do
    it "should return array of all documents with that term" do
      RetrievalLite::BooleanRetrieval.evaluate(corpus, "lorem").should == [document, document_replicated, document_with_duplicates, document_one_term]
    end
    it "should ignore case" do
      RetrievalLite::BooleanRetrieval.evaluate(corpus, "LOreM").should == [document, document_replicated, document_with_duplicates, document_one_term]
    end
  end

  describe "valid boolean retrieval" do
    it "should work for simple two term AND" do
      RetrievalLite::BooleanRetrieval.evaluate(corpus, "lorem AND ipsum").should == [document, document_replicated, document_with_duplicates]
    end
  end
end