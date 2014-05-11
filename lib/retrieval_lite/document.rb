class RetrievalLite::Document
  # the text of the document
  attr_reader :content
  # a hash of all terms of the documents to the frequency of each term
  attr_reader :term_frequencies
  # the id of the document
  attr_reader :id

  # splits the text of the document into an array of tokens
  #
  # @param content [String] the text of the document
  # @param opts [Hash] optional arguments to initializer
  # @option opts [String] :id the id of the document.  Defaults to object_id assigned by ruby
  def initialize(content, opts = {})
    @content = content
    @id = opts[:id] || object_id
    @term_frequencies = RetrievalLite::Tokenizer.parse_content(content)
  end

  # for debugging
  def print_tokens
    @term_frequencies.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  # @return [Integer] the total number of unique terms in the document
  def term_count
    @term_frequencies.size
  end

  # @return [Array<String>] the unique terms of the document
  def terms
    @term_frequencies.keys
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