module EmailSanitizer
  class Constants
    def self.email_regex
      local_part_regex = "[#{email_local_part_valid_chars}]+"
      /#{local_part_regex}@(?:[a-z0-9\-]+\.)+(?:museum|travel|[a-z]{2,4})/
    end

    def self.email_local_part_valid_chars
      'a-z0-9_\.%\+\-\''
    end
  end
end
