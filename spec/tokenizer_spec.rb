require 'spec_helper'

describe RetrievalLite::Tokenizer do
  describe "parse_content" do
    describe "for basic terms" do
      let (:basic_tf) do
        {
          "lorem" => 1,
          "ipsum" => 1,
          "dolor" => 1,
          "sit" => 1,
          "amet" => 1
        }
      end

      it "should split the content" do
        content = "lorem ipsum dolor sit amet"
        RetrievalLite::Tokenizer.parse_content(content).should == basic_tf
      end

      it "should ignore extra white spaces" do
        content = "lorem    ipsum  dolor \n sit   amet"
        RetrievalLite::Tokenizer.parse_content(content).should == basic_tf
      end

      it "should ignore punctuation" do
        content = "lorem ! @ #ipsum (dolor) sit * \  amet"
        RetrievalLite::Tokenizer.parse_content(content).should == basic_tf
      end

      it "should ignore capitalization" do
        content = "LOREM iPSuM dOLOR sit amet"
        RetrievalLite::Tokenizer.parse_content(content).should == basic_tf
      end

      it "should ignore any whitespaces in front and back of content" do
        content = "     lorem ipsum dolor sit amet    \n"
        RetrievalLite::Tokenizer.parse_content(content).should == basic_tf
      end
    end

    describe "for content with multiple terms" do
      let (:multiple_tf) do
        {
          "lorem" => 1,
          "ipsum" => 2,
          "dolor" => 3,
          "sit" => 4,
          "amet" => 5
        }
      end
      it "should not care about order" do
        content = "lorem ipsum ipsum dolor dolor dolor sit sit sit sit amet amet amet amet amet"
        RetrievalLite::Tokenizer.parse_content(content).should == multiple_tf

        content = "amet amet lorem dolor dolor sit sit ipsum ipsum sit amet dolor sit amet amet"
        RetrievalLite::Tokenizer.parse_content(content).should == multiple_tf
      end

      it "should consider capitalized terms to be the same" do
        content = "lorem IPSUM ipsum doLOR doLOR dolor SIT SIT SIT SIT amet ameT amET aMET AMET"
        RetrievalLite::Tokenizer.parse_content(content).should == multiple_tf
      end
    end

    describe "for special cases" do
      let(:foo_bar_hash) do
        {
          "foo" => 1,
          "bar" => 1
        }
      end

      it "should return empty hash if there are no terms" do
        RetrievalLite::Tokenizer.parse_content("").should == Hash.new
      end

      it "should ignore numbers" do
        RetrievalLite::Tokenizer.parse_content("1 2 3.14159").should == Hash.new
      end

      it "should ignore control characters" do
        RetrievalLite::Tokenizer.parse_content("\a\e\f\n\r\t\v").should == Hash.new
        RetrievalLite::Tokenizer.parse_content("\x07\x1B\f\n\r\t\v").should == Hash.new
      end

      it "should split words connected by hyphens" do
        RetrievalLite::Tokenizer.parse_content("foo-bar").should == foo_bar_hash
      end
      
      it "should split words connected by slashes" do
        RetrievalLite::Tokenizer.parse_content("foo/bar").should == foo_bar_hash
      end

      it "should split words connected by commas" do
        RetrievalLite::Tokenizer.parse_content("foo/bar").should == foo_bar_hash
      end
    end
  end
end