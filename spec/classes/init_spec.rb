require 'spec_helper'
describe 'upkeep' do

  context 'with defaults for all parameters' do
    it { should contain_class('upkeep') }
  end
end
