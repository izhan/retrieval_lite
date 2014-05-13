require "version"
require "set"

# Offers simple document retrieval from a corpus with a query
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

  # Creates a new Retrieval Lite document.  Upon initialization, the content
  # is parsed into individual tokens, and its term frequencies are recorded.
  #
  # @param content [String] the text of the document
  # @param opts [Hash] optional arguments to initializer
  # @option opts [String] :id the id of the document.  Defaults to object_id assigned by ruby
  # @return a new document containing the input text
  def new_document(content, opts = {})
    RetrievalLite::Document.new(content, opts)
  end

  # Creates a new Retrieval Lite corpus, a collection of documents.  Corpuses
  # do not modify nor own the documents in them, meaning documents must
  # be created first before adding them to the corpus.
  #
  # @param documents [Array<Document>] the documents of the corpus
  # @param opts [Hash] optional arguments to initializer
  # @option opts [Array<String>] :stop_words the words to ignore when creating tokens
  # @return [Corpus] either a new empty corpus or one with those documents
  def new_corpus(documents = [], opts = {})
    RetrievalLite::Corpus.new(documents, opts)
  end
end

require 'retrieval_lite/document'
require 'retrieval_lite/corpus'
require 'retrieval_lite/tokenizer'
require 'retrieval_lite/boolean_retrieval'
require 'retrieval_lite/tfidf_retrieval'
require 'retrieval_lite/vector'