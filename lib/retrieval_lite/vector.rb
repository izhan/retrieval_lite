module RetrievalLite::Vector
  # @param scores1 [Hash<String, Integer>] each term and its corresponding score in the first document
  # @param scores2 [Hash<String, Integer>] each term and its corresponding score in the second document
  # @return [Float] the cosine similarity of the two vectors representing the score of the documents
  def self.cosine_similarity(scores1, scores2)
    dot_product(frequencies1, frequencies2) / (euclidean_length(frequencies1) * euclidean_length(frequencies2))
  end

  # @param scores1 [Hash<String, Integer>] each term and its corresponding score in the first document
  # @param scores2 [Hash<String, Integer>] each term and its corresponding score in the second document
  # @return [Float] the dot product of the two vectors representing the score of the documents
  def self.dot_product(scores1, scores2)
    
  end

  # @param scores [Hash<String, Integer>] each term and its corresponding score in the document
  # @return [Float] the euclidean length of the vectors representing the score of the document
  def self.euclidean_length(scores)
    
  end
end