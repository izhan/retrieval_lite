class RetrievalLite::Document
  # the text of the document
  attr_reader :content
  # a Hash<String, Integer> of all terms of the documents to the frequency of each term
  attr_reader :term_frequencies
  # the id of the document
  attr_reader :id

  # Creates a new Retrieval Lite document.  Upon initialization, the content
  # is parsed into individual tokens, and its term frequencies are recorded.
  #
  # @param content [String] the text of the document
  # @param opts [Hash] optional arguments to initializer
  # @option opts [String] :id the id of the document.  Defaults to object_id assigned by ruby
  def initialize(content, opts = {})
    @content = content
    @id = opts[:id] || object_id
    @term_frequencies = RetrievalLite::Tokenizer.parse_content(content)
  end

  # @return [Integer] the total number of unique terms in the document
  def term_count
    @term_frequencies.size
  end

  # @return [Array<String>] the unique terms of the document
  def terms
    @term_frequencies.keys
  end

  # @param term [String]
  # @return [Integer] the number of times a term appears in the document
  def frequency_of(term)
    if @term_frequencies.has_key?(term)
      return @term_frequencies[term]
    else
      return 0
    end
  end

  # @param term [String]
  # @return [Boolean] whether a term appears in the document
  def contains?(term)
    @term_frequencies.has_key?(term)
  end

  # @return [Integer] the total number of terms (not unique) in the document
  def total_terms
    count = 0
    @term_frequencies.each do |key, value|
      count += value
    end
    return count
  end
end