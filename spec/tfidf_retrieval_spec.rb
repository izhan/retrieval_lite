require 'spec_helper'

describe RetrievalLite::TfIdfRetrieval do
  let (:document_one_term) do
    RetrievalLite::Document.new("lorem")
  end
  let (:document) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_with_duplicates) do
    RetrievalLite::Document.new("lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet")
  end
  let (:document_doubled) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet lorem ipsum dolor sit amet")
  end
  let (:document_both_terms) do
    RetrievalLite::Document.new("lorem ipsum")
  end
  let (:document_with_unique) do
    RetrievalLite::Document.new("lorem unique")
  end
  # sorted by lorem order
  let (:all_documents) do
    [document, document_with_duplicates, document_doubled, document_one_term, document_both_terms, document_with_unique]
  end
  let (:corpus) do
    RetrievalLite::Corpus.new(all_documents)
  end
  describe "one-term retrieval" do
    it "should return array with that term" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "lorem").should == all_documents
    end
    it "should ignore case" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "LOREM").should == all_documents
    end
  end
  describe "for no matches" do
    it "should return empty array for term not in any documents" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "foobar").should == []
    end
    it "should return empty array for empty string" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "").should == []
    end
  end
  describe "unnormalized dot product" do
    it "should order documents correctly" do

      #TODO
    end
    it "should have the correct scores" do

    end
  end
end