module RetrievalLite::Tokenizer
  # @param content [String] the text of the document
  # @return [Hash<String, Integer>] a hash that gives term frequency of content
  def self.parse_content(content)
    tokens = Hash.new(0) # initialize to 0

    # removes everything BUT the letters
    token_text = content.strip.downcase.gsub(/[^a-z\s]/, '').split(/\s+/)

    token_text.each do |t|
      tokens[t] += 1
    end

    tokens
  end
end