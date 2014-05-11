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
end