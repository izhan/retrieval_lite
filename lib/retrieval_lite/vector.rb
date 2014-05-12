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
    sum = 0
    if scores1.size > scores2.size
      scores1.each do |term, count|
        if scores2[term] != nil
          sum += count * scores2[term]
        end
      end
    else
      scores2.each do |term, count|
        if scores1[term] != nil
          sum += count * scores1[term]
        end
      end
    end
    
    return sum
  end

  # @param scores [Hash<String, Integer>] each term and its corresponding score in the document
  # @return [Float] the euclidean length of the vectors representing the score of the document
  def self.euclidean_length(scores)
    sum = 0

    scores.each do |term, count|
      sum += count * count
    end
    Math.sqrt(sum)
  end
end