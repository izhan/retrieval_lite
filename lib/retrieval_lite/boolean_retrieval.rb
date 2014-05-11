module RetrievalLite::BooleanRetrieval
  # Queries a corpus using a boolean expression with the standard operators,
  # AND, OR, NOT.  Only returns documents that satisfy the query, and does
  # not rank the documents in any way.
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @return [Array<Document>] unordered array of documents that satisfy the query
  def self.evaluate(corpus, query)
    if !is_valid?(query)
      raise "Boolean expression is not valid." # TODO better validation message?
    end

    corpus.documents_with(query)
  end

  private
    def self.is_valid?(query)
      true
    end
end