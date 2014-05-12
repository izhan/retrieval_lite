module RetrievalLite::Vector
  # @param scores1 [Array<Integer>] each term and its corresponding score in the first document
  # @param scores2 [Array<Integer>] each term and its corresponding score in the second document
  # @return [Float] the cosine similarity of the two vectors representing the score of the documents
  def self.cosine_similarity(scores1, scores2)
    dot_product(scores1, scores2) / (euclidean_length(scores1) * euclidean_length(scores2))
  end

  # @param scores1 [Array<Integer>] each term and its corresponding score in the first document
  # @param scores2 [Array<Integer>] each term and its corresponding score in the second document
  # @return [Float] the dot product of the two vectors representing the score of the documents
  def self.dot_product(scores1, scores2)
    raise "document vectors are not of same length" if scores1.size != scores2.size
    
    sum = 0
    for i in 0...scores1.size
      sum += scores1[i]*scores2[i]
    end

    return sum
  end

  # @param scores [Array<Integer>] each term and its corresponding score in the document
  # @return [Float] the euclidean length of the vectors representing the score of the document
  def self.euclidean_length(scores)
    sum = 0

    for i in 0...scores.size
      sum += scores[i] * scores[i]
    end

    Math.sqrt(sum)
  end
end