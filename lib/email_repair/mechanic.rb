module EmailRepair
  class Mechanic
    def repairs
      [
        CommonMistakeRepair,
        CommonDomainSuffixRepair,
        CommonDomainPeriodAdder,
        CommonDomainAtAdder,
        CommonDomainSwapRepair,
        EmailRegexRepair,
      ]
    end

    def repair_all(emails)
      emails = emails.reject(&:nil?).map(&:strip).reject { |email| email == '' }

      sanitized_emails = []
      invalid_emails = []

      emails.each do |email|
        repaired_email = repair(email)

        if repaired_email
          sanitized_emails << repaired_email
        else
          invalid_emails << email
        end
      end

      OpenStruct.new(
        sanitized_emails: sanitized_emails.uniq,
        invalid_emails: invalid_emails.uniq,
      )
    end

    def repair(email)
      return unless email

      repairs.each { |repair| email = repair.repair(email) }

      email
    end

    class CommonMistakeRepair
      def self.repair(email)
        email.downcase
          .gsub(/\s/, '')
          .sub(/@+/, '@')
          .sub(/\.c0m$/, '.com')
          .sub(/,[a-z]{2,4}$/) { |m| m.sub(',', '.') }
      end
    end

    class EmailRegexRepair
      def self.repair(email)
        match = email.match(/(#{EmailRepair::Constants.email_regex})/)
        match && match.captures.first
      end
    end

    class CommonDomainRepair
      def self.repair(*)
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

    class CommonDomainSuffixRepair < CommonDomainRepair
      def self.repair(email)
        common_domains.each do |name, suffix|
          email = "#{email}.#{suffix}" if email.match(/#{name}$/)
        end
        email
      end
    end

    class CommonDomainPeriodAdder < CommonDomainRepair
      def self.repair(email)
        common_domains.each do |name, suffix|
          regex = /#{name}#{suffix}$/
          email = email.sub(regex, "#{name}.#{suffix}") if email.match(regex)
        end
        email
      end
    end

    class CommonDomainAtAdder < CommonDomainRepair
      def self.repair(email)
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

    class CommonDomainSwapRepair < CommonDomainRepair
      def self.repair(email)
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
