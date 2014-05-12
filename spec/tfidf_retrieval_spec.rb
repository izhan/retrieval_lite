require 'spec_helper'

describe RetrievalLite::TfIdfRetrieval do
  let (:document) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_with_duplicates) do
    RetrievalLite::Document.new("lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet")
  end
  let (:document_doubled) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet lorem ipsum dolor sit amet")
  end
  let (:document_one_term) do
    RetrievalLite::Document.new("lorem")
  end
  let (:document_both_terms) do
    RetrievalLite::Document.new("lorem ipsum")
  end
  let (:all_documents) do
    [document, document_with_duplicates, document_doubled, document_one_term, document_both_terms]
  end
  let (:corpus) do
    RetrievalLite::Corpus.new(all_documents)
  end
  describe "one-term retrieval" do
    it "should return array with that term" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "lorem") == all_documents
    end
    it "should ignore case" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "LOREM") == all_documents
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