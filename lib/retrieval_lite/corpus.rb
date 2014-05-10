class RetrievalLite::Corpus
  attr_accessor :documents

  # @param documents [Array<Document>] the documents of the corpus
  # @param opts [Hash] optional arguments to initializer
  # @option opts [Array<String>] :stop_words the words to ignore when creating tokens
  def initialize(documents = [], opts = {})
    @documents = documents
  end

  # Adds a document to the corpus
  # @param document [Document] the document to be added
  def add(document)
    @documents << document
  end

  # @return [Integer] the number documents in the corpus
  def corpus_size
    documents.size
  end
end