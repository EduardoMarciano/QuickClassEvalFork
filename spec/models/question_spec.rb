require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Question, type: :model do
  describe '#input?' do
    it 'verifies if question has an input' do
      question = Question.create()

      expect(question.input?).to eq(false)
    end
  end
 
  describe '#objective?' do
=begin
    context 'question is objective' do
      it 'returns true if question is of objective format' do
        question = Question.create(input: "etc")
        Answer.create(question_id: 1)

        expect(question.objective?).to eq(true)
      end
    end
=end
    context 'question is not objective' do
      it 'returns false if question is not of objective format' do
        question = Question.create()
  
        expect(question.objective?).to eq(false)
      end
    end
  end

  describe '#valid_answer?' do
    it 'verifies if given answer is valid' do
      question = Question.create()

      expect(question.valid_answer?(nil)).to eq(true)
    end
  end

  describe '.to_csv' do
    it 'converts each question to a CSV' do
      Question.create(input: "etc", label: "test")
      Question.create(input: "more", label: "tests")
      form = Form.create()
      
      CSV.generate(headers: true, col_sep: ";") do |csv|
        Question.to_csv(csv, [], form)
      end
    end
  end

  describe '#to_csv' do
    it 'converts the question to a CSV' do
      question = Question.create(input: "more", label: "tests")
      form = Form.create()

      CSV.generate(headers: true, col_sep: ";") do |csv|
        question.to_csv(csv, 0, [], form)
      end
    end
  end

end
