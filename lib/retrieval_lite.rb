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
    evaluator_options = {}

    # evaluate like normal if it is not a boolean expression
    if opts[no_bool] || RetrievalLite::TfIdfRetrieval.has_boolean_operators?(query)
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, query)
    else
      RetrievalLite::TfIdfRetrieval.evaluate(corpus, query)
    end
  end
end

require 'retrieval_lite/document'
require 'retrieval_lite/corpus'
require 'retrieval_lite/tokenizer'
require 'retrieval_lite/boolean_retrieval'
require 'retrieval_lite/tfidf_retrieval'
require 'retrieval_lite/vector'