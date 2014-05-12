require 'spec_helper'

describe RetrievalLite::Document do
  describe "for a basic document" do
    let (:document) do
      RetrievalLite::Document.new("lorem ipsum dolor sit amet")
    end
    let (:capitalized_document) do
      RetrievalLite::Document.new("LorEM iPSUM DOLOR sit ameT")
    end
    let (:document_with_duplicates) do
      RetrievalLite::Document.new("lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet")
    end
    let (:basic_tf) do
      {
        "lorem" => 1,
        "ipsum" => 1,
        "dolor" => 1,
        "sit" => 1,
        "amet" => 1
      }
    end
    let (:multiple_tf) do
      {
        "lorem" => 1,
        "ipsum" => 2,
        "dolor" => 3,
        "sit" => 4,
        "amet" => 5
      }
    end

    describe "content of the document" do
      it "should have original content" do
        document.content.should == "lorem ipsum dolor sit amet"
        capitalized_document.content.should == "LorEM iPSUM DOLOR sit ameT"
        document_with_duplicates.content.should == "lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet"
      end
    end

    describe "the number of terms of the document" do
      it "should be correct for singleton terms" do
        document.term_count.should == 5
      end
      it "should not care about capitalization" do
        capitalized_document.term_count.should == 5
      end
      it "should be correct for duplicate terms" do
        document_with_duplicates.term_count.should == 5
      end
    end

    describe "id of the document" do
      it "should default to ruby's object_id" do
        document.id.should == document.object_id
      end
    end

    describe "term frequencies of the document" do
      it "should be correct for singleton terms" do
        document.term_frequencies.should == basic_tf
      end
      it "should be correct for capitalization" do
        capitalized_document.term_frequencies.should == basic_tf
      end
      it "should be correct for capitalization" do
        document_with_duplicates.term_frequencies.should == multiple_tf
      end
    end


    describe "frequencies of a term" do
      it "should be correct for term in document" do
        document.frequency_of("lorem").should == 1
        document_with_duplicates.frequency_of("ipsum").should == 2
      end
      it "should be zero for term not in document" do
        document.frequency_of("foo").should == 0
        document_with_duplicates.frequency_of("foo").should == 0
      end
    end

    describe "for blank document" do
      it "should not raise error on initialization" do
        expect { RetrievalLite::Document.new("") }.to_not raise_error
      end
    end
  end

  describe "optional parameters" do
    it "should allow for customized id" do
      doc = RetrievalLite::Document.new("lorem ipsum dolor sit amet", id: "foo")
      doc.id.should == "foo"
    end
  end
end