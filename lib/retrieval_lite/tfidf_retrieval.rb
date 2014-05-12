# @see http://nlp.stanford.edu/IR-book/pdf/irbookonlinereading.pdf
module RetrievalLite::TfIdfRetrieval
  # Queries a corpus using the tf-idf ranking algorithm and cosine similarity.
  # Returns documents ordered by tf-idf score.
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @return [Array<Document>] ordered array of documents that satisfy the query
  def self.evaluate(corpus, query)
    evaluate_with_scores(corpus, query).keys
  end

  # Queries a corpus using the tf-idf ranking algorithm and cosine similarity.
  # Same as #evaluate but returns a hash whose keys are documents and values
  # are the tf-idf score.
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @return [Hash<Document, Integer>] ordered array of documents that satisfy the query
  def self.evaluate_with_scores(corpus, query)
    query_document = RetrievalLite::Document.new(query)
    terms = query_document.term_frequencies.keys
    query_vector = query_document.term_frequencies.values # should be in same order as keys

    documents = Set.new # ordering of documents doesn't matter right now
    # gathering only the documents that contain at least one of those terms
    terms.each do |t|
      docs_with_term = corpus.documents_with(t)
      if docs_with_term
        docs_with_term.each do |d|
          if !documents.include?(d)
            documents << d
          end
        end
      end
    end

    scores = {}
    documents.each do |document|
      document_vector = Array.new(terms.size)
      terms.each_with_index do |term, index|
        document_vector[index] = tfidf_weight(corpus, document, term)
      end
      scores[document] = RetrievalLite::Vector.cosine_similarity(query_vector, document_vector)
    end

    # order it by score in descending order
    return Hash[scores.sort_by{|key, value| value}.reverse]
  end

  # Ranks a document in corpus using the tf-idf scoring.
  # 
  # @note tf-idf is slightly modified.  n_j (# of docs containing term j) is replaced with n_j + 1 to avoid divide by zero
  # 
  # @param corpus [Corpus] 
  # @param document [Document] 
  # @param term [String]
  # @return [Float] the tfidf weight of the term in the document
  def self.tfidf_weight(corpus, document, term)
    if corpus.document_frequency(term) == 0
      return 0
    else
      return document.frequency_of(term) * Math.log(1.0 * corpus.size/(corpus.document_frequency(term)))
    end
  end

  # Ranks a document in corpus using the normalized tf-idf scoring.
  # @see #tfidf_weight
  # 
  # @param corpus [Corpus] 
  # @param document [Document] 
  # @param term [String]
  # @return [Float] the normalized tfidf weight of the term in the document
  def self.normalized_tfidf_weight(corpus, document, term)
    normalize = 0

    document.terms.each do |t|
      weight = tfidf_weight(corpus, document, t)
      normalize += weight * weight
    end

    tfidf_weight(corpus, document, term) / Math.sqrt(normalize)
  end
end