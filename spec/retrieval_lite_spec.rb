require 'spec_helper'

describe RetrievalLite do
  let (:document_no_match) do
    RetrievalLite::Document.new("no-match")
  end
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
  let (:corpus_different) do
    RetrievalLite::Corpus.new([document_one_term, document, document_with_duplicates])
  end
  let(:corpus_small) do
    RetrievalLite::Corpus.new([document_one_term, document, document_no_match])
  end

  describe "when no options are passed" do
    it "should default to basic tf-idf" do
      scores = RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus_different, "lorem dolor sit")
      scores[document].should be_within(0.001).of(1.0)
      scores[document_with_duplicates].should be_within(0.001).of(0.953)
      scores[document_one_term].should be_within(0.001).of(0.0)
      RetrievalLite::TfIdfRetrieval.evaluate(corpus_different, "lorem dolor sit").should == [document, document_with_duplicates, document_one_term]
    end
  end
end