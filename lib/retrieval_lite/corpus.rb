class RetrievalLite::Corpus
  # the documents within the corpus
  attr_reader :documents
  # hash of a term to the array of documents that contain the particular term
  attr_reader :term_occurrences

  # @param documents [Array<Document>] the documents of the corpus
  # @param opts [Hash] optional arguments to initializer
  # @option opts [Array<String>] :stop_words the words to ignore when creating tokens
  def initialize(documents = [], opts = {})
    @documents = documents
    @term_occurrences = {}

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
    term_occurrences[term].size
  end

  private
    # adds each term of the document to the term_occurence hash 
    def update_term_occurrences(document)
      document.terms.each do |term|
        if @term_occurrences.has_key?(term)
          @term_occurrences[term] << document
        else
          @term_occurrences[term] = [document]
        end
      end
    end
end