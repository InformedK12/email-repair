require 'spec_helper'

module EmailRepair
  describe Constants, '.email_regex' do
    it 'allows capital letters' do
      expect('ICan.CaPitAliZe@hOwI.WanT')
        .to match(/\A#{EmailRepair::Constants.email_regex}\z/)
    end
  end
end
