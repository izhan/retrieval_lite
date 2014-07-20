require 'spec_helper'

describe RetrievalLite do
  include RetrievalLite

  let (:document_one_term) do
    new_document("lorem")
  end
  let (:document) do
    new_document("lorem ipsum dolor sit amet")
  end
  let (:document_with_duplicates) do
    new_document("lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet")
  end
  let (:document_doubled) do
    new_document("lorem ipsum dolor sit amet lorem ipsum dolor sit amet")
  end
  let (:document_both_terms) do
    new_document("lorem ipsum")
  end
  let (:document_with_unique) do
    new_document("lorem unique")
  end
  let (:document_no_match) do
    new_document("no-match")
  end
  let (:all_documents) do
    [document, document_with_duplicates, document_doubled, document_one_term, document_both_terms, document_with_unique, document_no_match]
  end
  let (:corpus) do
    new_corpus(all_documents)
  end
  let (:corpus_different) do
    new_corpus([document_one_term, document, document_with_duplicates])
  end

  describe "when no options are passed" do
    it "should default to basic tf-idf" do
      scores = evaluate_query_with_scores(corpus_different, "lorem dolor sit")
      scores[document].should be_within(0.001).of(1.0)
      scores[document_with_duplicates].should be_within(0.001).of(0.953)
      scores[document_one_term].should be_within(0.001).of(0.0)

      evaluate_query(corpus_different, "lorem dolor sit").should == [document, document_with_duplicates, document_one_term]
    end
  end

  describe "when boolean operators are present" do
    it "should first filter through boolean" do
      evaluate_query(corpus, "lorem AND NOT dolor").should == [document_one_term, document_both_terms, document_with_unique]
      evaluate_query(corpus, "(lorem AND unique) OR no-match").should == [document_with_unique, document_no_match]
      evaluate_query(corpus, "lorem AND ipsum AND dolor AND sit AND amet").should == [document_doubled, document, document_with_duplicates]
      evaluate_query(corpus, "lorem AND no-match").should == []
    end
  end

  describe "with punctuation" do
    it "should retrieve it as normal" do
      evaluate_query(corpus, "lorem. AND NOT dolor!").should == [document_one_term, document_both_terms, document_with_unique]
      evaluate_query(corpus, "(lorem-- AND !unique) OR no-match").should == [document_with_unique, document_no_match]
      evaluate_query(corpus, "@lorem AND @ipsum AND @dolor AND @sit AND @amet").should == [document_doubled, document, document_with_duplicates]
      evaluate_query(corpus, "||lorem AND no-match").should == []
    end
  end
end