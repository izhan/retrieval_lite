require 'spec_helper'

describe RetrievalLite::Vector do
  describe "dot product" do
    it "should compute correctly for vectors length 1" do
      RetrievalLite::Vector.dot_product([3], [5]).should == 15
    end
    it "should compute correctly for longer vectors" do
      RetrievalLite::Vector.dot_product([2, 3], [4, 5]).should == 23
    end
    it "should raise error for unequal sized arrays" do
      expect { RetrievalLite::Vector.dot_product([2, 3], [4]) }.to raise_error
    end
  end

  describe "euclidean length" do
    it "should calculate it for vectors length 1" do
      RetrievalLite::Vector.euclidean_length([1]).should == 1
    end
    it "should calculate it for zero vectors" do
      RetrievalLite::Vector.euclidean_length([0, 0, 0]).should == 0
    end
    it "should calculate it for longer vectors" do
      RetrievalLite::Vector.euclidean_length([3, 4]).should == 5
    end
  end
end