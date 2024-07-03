require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe MultipleChoiceQuestion, type: :model do
  let(:instance) { MultipleChoiceQuestion.new }

  describe '#input?' do
    it 'always returns true' do
      expect(instance.input?).to eq(true)
    end
  end

  describe '#options' do
    context 'when format is nil' do
      it 'returns an empty array' do
        instance[:format] = nil
        expect(instance.options).to eq([])
      end
    end

    context 'when format is an empty string' do
      it 'returns an empty array' do
        instance[:format] = ''
        expect(instance.options).to eq([])
      end
    end

    context 'when format contains multiple values' do
      it 'returns an array of those values' do
        instance[:format] = 'value1|value2|value3'
        expect(instance.options).to eq(%w[value1 value2 value3])
      end
    end

    context 'when format contains a single value' do
      it 'returns an array with that single value' do
        instance[:format] = 'value1'
        expect(instance.options).to eq(['value1'])
      end
    end
  end

  describe '#valid_answer?' do
    context 'when input is included in options' do
      it 'returns true' do
        instance[:format] = 'value1|value2|value3'
        expect(instance.valid_answer?('value2')).to be true
      end
    end

    context 'when input is not included in options' do
      it 'returns false' do
        instance[:format] = 'value1|value2|value3'
        expect(instance.valid_answer?('value4')).to be false
      end
    end

    context 'when options is empty' do
      it 'returns false' do
        instance[:format] = nil
        expect(instance.valid_answer?('value1')).to be false
      end
    end
  end
end
