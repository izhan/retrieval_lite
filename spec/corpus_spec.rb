require 'spec_helper'

describe RetrievalLite::Corpus do
  let (:document) do
    RetrievalLite::Document.new("lorem ipsum dolor sit amet")
  end
  let (:document_replica) do
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

  describe "with optional parameters" do
    it "should ignore any stopwords (not case sensitive)" do
      stop_words = ["lorem", "IPSum"]
      corpus = RetrievalLite::Corpus.new([document], stop_words: stop_words)
      corpus.documents_with("lorem").should == nil
      corpus.documents_with("ipsum").should == nil
    end
  end
end