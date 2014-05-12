module RetrievalLite::BooleanRetrieval
  # Gathers up all documents of a corpus that satisfy a boolean expression 
  # with the standard operators: AND, OR, NOT.  Does not order the documents in 
  # particular any way.  Assumes that all boolean operators are separated by
  # white space on either side.
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

  def self.is_boolean_expression(query)
    /AND|OR|NOT/ === query
  end

  private
    def self.is_valid?(query)
      true
    end
end