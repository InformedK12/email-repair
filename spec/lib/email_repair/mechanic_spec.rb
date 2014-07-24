require 'spec_helper'

module EmailRepair
  describe Mechanic, '#repair' do

    let(:mechanic) { Mechanic.new }

    it 'returns clean emails as is' do
      # Rant about apostrophe in email
      # http://www.stuffaboutcode.com/2013/02/validating-email-address-bloody.html
      good_emails = %w(
        b@b.com
        lobatifricha@gmail.com
        mrspicy+whocares@whatevs.com
        your.mom@the.museum
        martin.o'hanlon@mycompany.com
      )

      good_emails.each do |good_email|
        expect(mechanic.repair(good_email)).to eq good_email
      end
    end

    it 'returns nil for nil email' do
      expect(mechanic.repair(nil)).to be_nil
    end

    it 'returns nil for strings that have no email' do
      ['', ' ', 'NOT AN EMAIL', 'b at b dot com'].each do |not_email|
        expect(mechanic.repair(not_email)).to be_nil
      end
    end

    it 'returns the email with the spaces stripped out' do
      space_mails = {
        'somebody@gmail.com ' => 'somebody@gmail.com',
        'email withspace@blah.com' => 'emailwithspace@blah.com',
        'emailwithspace@blah .com' => 'emailwithspace@blah.com',
      }

      space_mails.each do |in_mail, out_mail|
        expect(mechanic.repair(in_mail)).to eq out_mail
      end
    end

    it 'adds missing .com' do
      no_com_mails = %w(blah@gmail bloo@yahoo blee@hotmail)
      no_com_mails.each do |no_com_mail|
        expect(mechanic.repair(no_com_mail)).to eq "#{no_com_mail}.com"
      end
    end

    it 'trims extra @ signs' do
      expect(mechanic.repair('b@@@b.com')).to eq 'b@b.com'
    end

    it 'changes c0m to com' do
      expect(mechanic.repair('b0b@b0b.c0m')).to eq 'b0b@b0b.com'
    end

    it 'fixes a missing .' do
      expect(mechanic.repair('who@gmailcom')).to eq 'who@gmail.com'
      expect(mechanic.repair('what@hotmailcom')).to eq 'what@hotmail.com'
    end

    it 'fixes letter swap' do
      expect(mechanic.repair('bloo@yhaoo.com')).to eq 'bloo@yahoo.com'
    end

    it 'adds a missing @ for common domains' do
      dirty_emails = {
        'blahgmailcom' => 'blah@gmail.com',
        'blooearthlink.net' => 'bloo@earthlink.net',
        'gooberssbcglobal.net' => 'goobers@sbcglobal.net',
        'booger800yahoo.com' => 'booger800@yahoo.com',
        'butt2630att.net' => 'butt2630@att.net',
        'byjove28024aol.com' => 'byjove28024@aol.com',
      }

      dirty_emails.each do |in_mail, out_mail|
        expect(mechanic.repair(in_mail)).to eq out_mail
      end
    end

    it 'swaps a # for an @ for common domains' do
      expect(mechanic.repair('pound#yahoo.com')).to eq 'pound@yahoo.com'
    end

    it 'swaps a - for an @ for common domains' do
      dirty_emails = {
        'chou.sa+aea-gmail.com' => 'chou.sa+aea@gmail.com',
        'sarah+aea-chalkschools.com' => 'sarah+aea@chalkschools.com',
      }
      dirty_emails.each do |in_mail, out_mail|
        expect(mechanic.repair(in_mail)).to eq out_mail
      end
    end

    it 'replaces , with .' do
      expect(mechanic.repair('b@b,com')).to eq 'b@b.com'
    end

    it 'grabs an email out of the string' do
      dirty_emails = {
        'Awesome,Test Driver,aperson@gmail.com' => 'aperson@gmail.com',
        'one@email.com, another@email.com' => 'one@email.com',
        'one@email.com,another@email.com' => 'one@email.com',
        'one@email.com;another@email.com' => 'one@email.com',
        '<one@email.com>' => 'one@email.com',
      }

      dirty_emails.each do |in_mail, out_mail|
        expect(mechanic.repair(in_mail)).to eq out_mail
      end
    end

    it 'downcases emails' do
      dirty_emails = {
        'ONE@email.com, another@email.com' => 'one@email.com',
        'email WITHSPACE@blah.com' => 'emailwithspace@blah.com',
        'lobatifricha@GMAIL.com' => 'lobatifricha@gmail.com',
      }

      dirty_emails.each do |in_mail, out_mail|
        expect(mechanic.repair(in_mail)).to eq out_mail
      end
    end

  end
end
