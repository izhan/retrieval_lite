require "version"
require "set"

module RetrievalLite
  # Queries a corpus first by filtering it using a boolean evaluator and then
  # using the tf-idf ranking algorithm and cosine similarity.
  # Returns documents ordered by tf-idf score.
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @option opts [Boolean] :no_bool prevent the boolean filter
  # @return [Array<Document>] ordered array of documents that satisfy the query
  def evaluate_query(corpus, query, opts = {})
    evaluate_query_with_scores(corpus, query, opts).keys
  end

  # Queries a corpus first by filtering it using a boolean evaluator and then
  # using the tf-idf ranking algorithm and cosine similarity.
  # Returns Hash of documents to their respective TF-IDF scores
  # @see evaluate_query
  # 
  # @param corpus [Corpus] the collection of documents
  # @param query [String] the boolean query to be evaluated
  # @option opts [Boolean] :no_bool prevent the boolean filter
  # @return [Hash<Document, Integer>] ordered array of documents that satisfy the query
  def evaluate_query_with_scores(corpus, query, opts = {})
    evaluator_options = {}

    # evaluate like normal if it is not a boolean expression
    if opts[:no_bool] || !RetrievalLite::BooleanRetrieval.has_boolean_operators?(query)
      RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus, query)
    else
      documents = RetrievalLite::BooleanRetrieval.evaluate(corpus, query)
      RetrievalLite::TfIdfRetrieval.evaluate_with_scores(corpus, query, { document_set: documents })
    end
  end
end

require 'retrieval_lite/document'
require 'retrieval_lite/corpus'
require 'retrieval_lite/tokenizer'
require 'retrieval_lite/boolean_retrieval'
require 'retrieval_lite/tfidf_retrieval'
require 'retrieval_lite/vector'