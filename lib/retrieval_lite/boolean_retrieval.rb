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
    if !is_valid_expression?(query)
      raise "Boolean expression can only consist of boolean operators and alphanumeric characters."
    end

    corpus.documents_with(query)
  end

  # @param query [String] the boolean query to be evaluated
  # @return [Boolean] whether query contains any boolean operators
  def self.has_boolean_operators?(query)
    /AND|OR|NOT/ === query
  end


  # @param query [String] the boolean query to be evaluated
  # @return [Boolean] whether query contains any non-alphanumeric characters besides parenthesis and whitespace
  def self.is_valid_expression?(query)
    !(/(AND|OR|NOT)\s*\)/ === query)
  end
end