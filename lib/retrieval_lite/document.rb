class RetrievalLite::Document
  # the text of the document
  attr_reader :content
  # the text of the document broken up into IR tokens
  attr_reader :tokens
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