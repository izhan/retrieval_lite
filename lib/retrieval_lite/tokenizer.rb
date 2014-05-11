module RetrievalLite::Tokenizer
  SPECIAL_SEPARATERS = ['[', ']', '\\', ';', '\'', ',', '.', '/', '!', '@', '#', '%', '&', '*', '(', ')', '_', '{', '}', ':', '"', '?', '=', '`', '~', '$', '^', '+', '|', '<', '>']

  # @param content [String] the text of the document
  # @return [Hash<String, Integer>] a hash that gives term frequency of content
  def self.parse_content(content)
    tokens = Hash.new(0) # initialize to 0

    # removes everything BUT the letters
    token_text = content.strip.downcase.split(/#{separaters_regex}/)

    token_text.each do |t|
      # also validates whether there are no other special characters left in there
      if has_hyphen?(t)
        tokens[t] += 1
      else
        # get rid of any extra symbols we might have forgotten.
        term = t.gsub(/[^a-z]/, '')

        # just in case the entire string was just non-characters
        if term != ''
          tokens[term] += 1
        end
      end
    end

    tokens
  end

  private
    # separates by whitespace and any special characters
    def self.separaters_regex
      regex = "\s+" # captures all white spaces
      SPECIAL_SEPARATERS.each do |s|
        regex = regex + '|' + Regexp.quote(s)
      end
      return Regexp.new(regex)
    end

    # detects whether term is hyphenated
    def self.has_hyphen?(term)
      term =~ /\A[a-z]+\-[a-z]+\Z/
    end
end