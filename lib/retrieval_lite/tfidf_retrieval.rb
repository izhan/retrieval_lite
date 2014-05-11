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

  # Ranks a document in corpus using the tf-idf scoring.
  # 
  # @note tf-idf is slightly modified.  n_j (# of docs containing term j) is replaced with n_j + 1 to avoid divide by zero
  # 
  # @param corpus [Corpus] 
  # @param document [Document] 
  # @param term [String]
  def self.tfidf_weight(corpus, document, term)
    document.frequency_of(term) * Math.log(corpus.size/(corpus.document_frequency(term)))
  end

  # Ranks a document in corpus using the normalized tf-idf scoring.
  # @see #tfidf_weight
  # @note tf-idf is slightly modified.  n_j (# of docs containing term j) is replaced with n_j + 1 to avoid divide by zero
  # 
  # @param corpus [Corpus] 
  # @param document [Document] 
  # @param term [String]
  def self.normalized_tfidf_weight(corpus, document, term)
    length_of_vector = 0

    documents_with(term).each do |d|
      weight = tfidf_weight(corpus, d, term)
      length_of_vector += weight * weight
    end

    tfidf_weight(corpus, document, term) / Math.sqrt(length_of_vector)
  end
end