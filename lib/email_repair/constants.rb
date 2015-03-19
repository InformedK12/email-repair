module EmailRepair
  class Constants
    class << self
      def email_regex
        local_part_regex = "[#{valid_chars}]" \
          "([#{valid_chars_with_dot}]*[#{valid_chars}])?"
        /#{local_part_regex}@(?:[a-z0-9\-]+\.)+(?:museum|travel|[a-z]{2,4})/
      end

    private

      def valid_chars_with_dot
        "#{valid_chars}\."
      end

      def valid_chars
        'a-z0-9_%\+\-\''
      end
    end
  end
end
