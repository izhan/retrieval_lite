module RetrievalLite::TfIdfRetrieval
  # Queries a corpus using the tf-idf ranking algorithm and cosine similarity.
  # Returns documents ordered by tf-idf score.
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @return [Array<Document>] ordered array of documents that satisfy the query
  def self.evaluate(corpus, query)
    token_array = RetrievalLite::Tokenizer.parse_content(query)

    corpus.documents_with(token_array.first)
  end

  # Queries a corpus using the tf-idf ranking algorithm and cosine similarity.
  # Same as #evaluate but returns a hash whose keys are documents and values
  # are the tf-idf score.
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @return [Array<Document>] ordered array of documents that satisfy the query
  def self.evaluate_with_scores(corpus, query)
    token_array = RetrievalLite::Tokenizer.parse_content(query)

    documents = corpus.documents_with(token_array.first)
  end

  # @param document [Document] 
  # @param term [String]
  def self.tfidf_score(document, term)
    
  end
end