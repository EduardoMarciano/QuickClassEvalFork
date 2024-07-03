require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Template, type: :model do
  describe '#to_s' do
    it 'returns the correct string representation' do
      template = Template.new(id: 1)
      expect(template.to_s).to eq('Modelo #1')
    end
  end
end
