# A collection of documents
class RetrievalLite::Corpus
  # the documents within the corpus
  attr_reader :documents
  # hash of a term to the array of documents that contain the particular term
  attr_reader :term_occurrences

  # Creates a new Retrieval Lite corpus, a collection of documents.  Corpuses
  # do not modify nor own the documents in them, meaning documents must
  # be created first before adding them to the corpus.
  #
  # @param documents [Array<Document>] the documents of the corpus
  # @param opts [Hash] optional arguments to initializer
  # @option opts [Array<String>] :stop_words the words to ignore when creating tokens
  def initialize(documents = [], opts = {})
    @documents = documents
    @term_occurrences = {}
    @stop_words = opts[:stop_words] || []
    # stop_words should be lowercased since tokens are in lowercase
    @stop_words.each do |w|
      w.downcase!
    end
    @stop_words = Set.new @stop_words # faster .include?

    documents.each do |d|
      update_term_occurrences(d)
    end
  end

  # Adds a document to the corpus
  # @param document [Document] the document to be added
  def add(document)
    @documents << document
    update_term_occurrences(document)
  end

  # @return [Integer] the number documents in the corpus
  def size
    documents.size
  end

  # @param term [String] the term to retrieve the documents for
  # @return [Array<Document>] the array of documents containing the particular term or nil if no such occurence
  def documents_with(term)
    term_occurrences[term]
  end

  # @param term [String] the query term for the documents
  # @return [Integer] the number of documents that contain the particular term
  def document_frequency(term)
    if term_occurrences[term]
      return term_occurrences[term].size
    else
      return 0
    end
  end

  private
    # adds each term of the document to the term_occurence hash 
    def update_term_occurrences(document)
      document.terms.each do |term|
        if @term_occurrences.has_key?(term)
          @term_occurrences[term] << document
        elsif !@stop_words.include?(term)
          @term_occurrences[term] = [document]
        end
      end
    end
end