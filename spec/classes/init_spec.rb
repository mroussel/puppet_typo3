require 'spec_helper'
describe 'typo3' do
  context 'with default values for all parameters' do
    it { should contain_class('typo3') }
  end
end
