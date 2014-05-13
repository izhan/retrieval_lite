require 'spec_helper'

describe RetrievalLite::TfIdfRetrieval do
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

  describe "calculating tf-idf scores" do
    describe "term that all documents have" do
      it "should have correct tf-idf" do
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_one_term, "lorem").should be_within(0.001).of(0)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document, "lorem").should be_within(0.001).of(0)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_with_duplicates, "lorem").should be_within(0.001).of(0)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_doubled, "lorem").should be_within(0.001).of(0)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_both_terms, "lorem").should be_within(0.001).of(0)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_with_unique, "lorem").should be_within(0.001).of(0)
      end
    end

    describe "term that a few documents have" do
      it "should have correct tf-idf" do
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document, "ipsum").should be_within(0.001).of(0.405)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_with_duplicates, "ipsum").should be_within(0.001).of(0.811)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_doubled, "ipsum").should be_within(0.001).of(0.811)
        RetrievalLite::TfIdfRetrieval.tfidf_weight(corpus, document_both_terms, "ipsum").should be_within(0.001).of(0.405)
      end
    end
  end

  describe "calculating normalized tf-idf scores" do
    describe "term that a few documents have" do
      it "should have correct tf-idf" do
        RetrievalLite::TfIdfRetrieval.normalized_tfidf_weight(corpus, document, "ipsum").should be_within(0.001).of(0.320)
        RetrievalLite::TfIdfRetrieval.normalized_tfidf_weight(corpus, document_with_duplicates, "ipsum").should be_within(0.001).of(0.163)
        RetrievalLite::TfIdfRetrieval.normalized_tfidf_weight(corpus, document_doubled, "ipsum").should be_within(0.001).of(0.320)
        RetrievalLite::TfIdfRetrieval.normalized_tfidf_weight(corpus, document_both_terms, "ipsum").should be_within(0.001).of(1.0)
      end
    end
  end

  describe "calculating total tf-idf scores" do
    describe "for when all documents of corpus has a term" do
      it "should have score of zero for each document" do
        scores = RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus, "lorem")
        scores.size.should == all_documents.size
        scores.values.each do |v|
          v.should == 0
        end
      end
    end
    describe "term that only one document has" do
      it "should return the correct score" do
        scores = RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus, "unique")
        scores.size.should == 1
        scores[document_with_unique].should be_within(0.001).of(1.0)
      end
    end
    describe "term that a few documents have" do
      it "should return the correct score" do
        scores = RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus, "ipsum")
        scores.size.should == 4
        scores[document].should be_within(0.001).of(0.320)
        scores[document_with_duplicates].should be_within(0.001).of(0.163)
        scores[document_doubled].should be_within(0.001).of(0.320)
        scores[document_both_terms].should be_within(0.001).of(1.0)
      end
    end
  end

  describe "one-term retrieval" do
    it "should return array with that term" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "lorem").should =~ all_documents
    end
    it "should ignore case" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "LOREM").should =~ all_documents
    end
  end

  describe "when corpus has only one document containing term" do
    it "should return array with only that document" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, "unique").should == [document_with_unique]
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

  describe "multiple-term retrieval" do
    it "should order documents correctly" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus_different, "lorem dolor sit").should == [document, document_with_duplicates, document_one_term]
    end
    it "should have the correct scores" do
      scores = RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus_different, "lorem dolor sit")
      scores[document].should be_within(0.001).of(1.0)
      scores[document_with_duplicates].should be_within(0.001).of(0.953)
      scores[document_one_term].should be_within(0.001).of(0.0)
    end
  end

  describe "documents with same frequency but longer lengths" do
    it "order should favor shorter documents" do
      RetrievalLite::TfIdfRetrieval.evaluate(corpus_small, "lorem").should == [document_one_term, document]
    end
    it "shorter documents should rank higher" do
      scores = RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus_small, "lorem")
      scores[document_one_term].should > scores[document]
    end
  end
end