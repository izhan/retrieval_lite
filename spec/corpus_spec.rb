require 'spec_helper'

describe RetrievalLite::Corpus do
  let (:document) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_replicated) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_with_duplicates) do
    RetrievalLite::Document.new("lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet")
  end
  let (:document_two) do
    RetrievalLite::Document.new("Mauris ullamcorper, tortor et consequat sagittis.")
  end
  let (:document_three) do
    RetrievalLite::Document.new("Pellentesque felis lectus, lacinia nec mauris non.")
  end
  let (:document_paragraph) do
    RetrievalLite::Document.new("In semper enim non ullamcorper venenatis. 
      Sed dictum metus condimentum libero ullamcorper, eget scelerisque risus congue. 
      Morbi tempus rhoncus ante, at varius sem adipiscing eu. Sed ut purus pretium, 
      consequat velit et, ultricies magna. Etiam sit amet elit mi. Sed et nibh non nibh 
      vestibulum hendrerit vitae dapibus lectus. Aenean eget odio vitae tortor elementum 
      euismod non nec eros. Nunc id convallis magna. Aliquam ultrices dignissim ipsum, 
      a accumsan enim faucibus non. Pellentesque a felis quis diam blandit tempor. 
      In aliquet laoreet tortor, at adipiscing diam scelerisque ut."
      )
  end
  let (:all_documents) do
    [document, document_replicated, document_with_duplicates, document_two, document_three, document_paragraph]
  end

  describe "for empty corpus" do
    let (:corpus) do
      RetrievalLite::Corpus.new
    end

    it "should have size of zero" do
      corpus.size.should == 0
    end
    it "should not error when querying terms" do
      expect { corpus.documents_with("foo") }.to_not raise_error
      expect { corpus.document_frequency("foo") }.to_not raise_error
    end
  end

  describe "for basic one-document corpus" do
    let (:corpus) do
      RetrievalLite::Corpus.new([document])
    end

    it "should have size of one" do
      corpus.size.should == 1
    end
    it "should give us correct document frequencies" do
      terms = ["lorem", "ipsum", "dolor", "sit", "amet"]
      terms.each do |t|
        corpus.document_frequency(t).should == 1
      end
      corpus.document_frequency("foo").should == 0
    end
    it "should return document when queried" do
      terms = ["lorem", "ipsum", "dolor", "sit", "amet"]
      terms.each do |t|
        corpus.documents_with(t).should == [document]
      end
      corpus.documents_with("foo").should == nil
    end
  end

  describe "for two-identical-document corpus" do
    let (:corpus) do
      RetrievalLite::Corpus.new([document, document_replicated])
    end
    it "should give us correct document frequencies" do
      terms = ["lorem", "ipsum", "dolor", "sit", "amet"]
      terms.each do |t|
        corpus.document_frequency(t).should == 2
      end
      corpus.document_frequency("foo").should == 0
    end
    it "should return document when queried" do
      terms = ["lorem", "ipsum", "dolor", "sit", "amet"]
      terms.each do |t|
        corpus.documents_with(t).should == [document, document_replicated]
      end
      corpus.documents_with("foo").should == nil
    end
  end

  describe "for multiple-document corpus" do
    let (:corpus) do
      RetrievalLite::Corpus.new(all_documents)
    end

    it "should have the correct size" do
      corpus.size.should == 6
    end

    # TODO are more comprehensive tests needed....?
    it "should give us correct document frequencies" do
      corpus.document_frequency("lorem").should == 3
      corpus.document_frequency("semper").should == 1
    end
  end

  describe "adding in documents one at a time" do
    let (:correct_corpus) do
      RetrievalLite::Corpus.new(all_documents)
    end
    let (:corpus) do
      RetrievalLite::Corpus.new
    end

    it "should be same as initializing corpus with all documents" do
      all_documents.each do |d|
        corpus.add(d)
      end
      corpus.documents.should == correct_corpus.documents
    end
  end

  describe "with optional parameters" do
    it "should ignore any stopwords (not case sensitive)" do
      stop_words = ["lorem", "IPSum"]
      corpus = RetrievalLite::Corpus.new([document], stop_words: stop_words)
      corpus.documents_with("lorem").should == nil
      corpus.documents_with("ipsum").should == nil
    end
  end
end