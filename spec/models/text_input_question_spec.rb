require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe TextInputQuestion, type: :model do
  let(:instance) { TextInputQuestion.new }

  describe '#input?' do
    it 'always returns true' do
      expect(instance.input?).to eq(true)
    end
  end
end
