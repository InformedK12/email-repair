module EmailRepair
  class Constants
    class << self
      def email_regex
        local_part_regex = "[#{valid_chars}]" \
          "([#{valid_chars_with_dot}]*[#{valid_chars}])?"
        /#{local_part_regex}@(?:[a-zA-Z0-9\-]+\.)+(?:[a-zA-Z]{2,24})/
      end

    private

      def valid_chars_with_dot
        "#{valid_chars}\."
      end

      def valid_chars
        'a-zA-Z0-9_%\+\-\''
      end
    end
  end
end
