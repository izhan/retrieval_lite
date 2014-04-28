class RetrievalLite::Document
  attr_reader :content
  attr_reader :tokens

  def initialize(content, opts = {})
    @content = content
    @tokens = Hash.new(0) # initialize to zero

    token_text = content.strip.split(/\s+/)

    token_text.each do |t|
      @tokens[t] += 1
    end
  end

  def print_tokens
    tokens.each do |key, value|
      puts "#{key}: #{value}"
    end
  end

  def token_size
    tokens.size
  end
end