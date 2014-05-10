class RetrievalLite::Document
  # the text of the document
  attr_reader :content
  # the text of the document broken up into IR tokens
  attr_reader :tokens

  # splits the text of the document into an array of tokens
  #
  # @param content [String] the text of the document
  # @param opts [Hash] optional arguments
  def initialize(content, opts = {})
    @content = content
    @tokens = Hash.new(0) # initialize to zero

    token_text = content.strip.split(/\s+/)

    token_text.each do |t|
      @tokens[t] += 1
    end
  end

  # for debugging
  def print_tokens
    tokens.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  # @return [Integer] the number documents in the corpus
  def token_size
    tokens.size
  end
end