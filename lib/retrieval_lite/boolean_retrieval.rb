# Gathers documents that satisfy boolean expression
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
      raise "Each boolean operator (AND, OR, NOT) must operate on two terms."
    end

    # must strip all non alphanumeric characters
    query = strip_query(query)

    # must have spaces in front and back for next line
    query = " " + query + " " 

    # replace all operators with corresponding operators
    query = query.gsub("AND", "\&\&").gsub("OR", "\|\|").gsub("NOT", "!")

    # replace all terms with corresponding functions.  includes hyphenated words
    query.gsub!(/[a-zA-Z0-9]+(-[a-zA-Z0-9]+)?/) do |q|
       " document.contains?(\"" + q.downcase + "\") "
    end

    output_documents = []
    corpus.documents.each do |document|
      if eval(query)
        output_documents << document
      end
    end

    return output_documents
  end

  # @param query [String] the boolean query to be evaluated
  # @return [Boolean] whether query contains any boolean operators
  def self.has_boolean_operators?(query)
    /AND|OR|NOT/ === query
  end

  # @note all other invalid expressions should be caught later on
  # @param query [String] the boolean query to be evaluated
  # @return [Boolean] whether query ends parenthesis correctly
  def self.is_valid_expression?(query)
    !(/(AND|OR|NOT)\s*\)/ === query)
  end

  # @param query [String] the boolean query to be evaluated
  # @return [String] a query removed of any non-alphanumeric characters besides parenthesis and whitespace
  def self.strip_query(query)
    # remove non-alphanumeric
    query = query.gsub(/[^a-zA-Z0-9\s\(\)\-]/, " ")

    # getting rid of stray hyphens
    query = query.gsub(/\-\-+/, " ").gsub(/\s+\-\s+/, " ")
  end
end