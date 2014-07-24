module EmailSanitizer
  class Sanitizer
    def sanitizers
      [
        CommonMistakeSanitizer,
        CommonDomainSuffixSanitizer,
        CommonDomainPeriodAdder,
        CommonDomainAtAdder,
        CommonDomainSwapSanitizer,
        EmailRegexSanitizer,
      ]
    end

    def sanitize(email)
      return unless email

      sanitizers.each { |sanitizer| email = sanitizer.sanitize(email) }

      email
    end

    class CommonMistakeSanitizer
      def self.sanitize(email)
        email.downcase
          .gsub(/\s/, '')
          .sub(/@+/, '@')
          .sub(/\.c0m$/, '.com')
          .sub(/,[a-z]{2,4}$/) { |m| m.sub(',', '.') }
      end
    end

    class EmailRegexSanitizer
      def self.sanitize(email)
        match = email.match(/(#{EmailSanitizer::Constants.email_regex})/)
        match && match.captures.first
      end
    end

    class CommonDomainSanitizer
      def self.sanitize(*)
        fail 'not implemented'
      end

      def self.common_domains
        {
          'gmail' => 'com',
          'yahoo' => 'com',
          'hotmail' => 'com',
          'att' => 'net',
          'chalkschools' => 'com',
          'sbcglobal' => 'net',
          'aol' => 'com',
          'earthlink' => 'net',
        }
      end
    end

    class CommonDomainSuffixSanitizer < CommonDomainSanitizer
      def self.sanitize(email)
        common_domains.each do |name, suffix|
          email = "#{email}.#{suffix}" if email.match(/#{name}$/)
        end
        email
      end
    end

    class CommonDomainPeriodAdder < CommonDomainSanitizer
      def self.sanitize(email)
        common_domains.each do |name, suffix|
          regex = /#{name}#{suffix}$/
          email = email.sub(regex, "#{name}.#{suffix}") if email.match(regex)
        end
        email
      end
    end

    class CommonDomainAtAdder < CommonDomainSanitizer
      def self.sanitize(email)
        common_domains.each do |name, suffix|
          punc_regex = /[.#-]#{name}.#{suffix}$/
          if email.match(punc_regex)
            email = email.sub(punc_regex, "@#{name}.#{suffix}")
          elsif email.match(/[^@]#{name}.#{suffix}$/)
            email = email.sub(/#{name}.#{suffix}$/, "@#{name}.#{suffix}")
          end
        end
        email
      end
    end

    class CommonDomainSwapSanitizer < CommonDomainSanitizer
      def self.sanitize(email)
        swapped_names.each do |swapped, real|
          suffix = common_domains[real]
          regex = /#{swapped}.#{suffix}$/
          email = email.sub(regex, "#{real}.#{suffix}") if email.match(regex)
        end
        email
      end

      def self.swapped_names
        @domain_keys ||= common_domains.keys
        @swapped_names ||= @domain_keys.each_with_object({}) do |name, result|
          swap_name(name).each { |swapped_name| result[swapped_name] = name }
        end
      end

      def self.swap_name(str)
        result = []
        (str.length - 1).times do |pos|
          beginning = str[0...pos]
          middle = "#{str[pos + 1]}#{str[pos]}"
          the_end = str[(pos + 2)..-1]
          result << "#{beginning}#{middle}#{the_end}"
        end
        result
      end
    end
  end
end
