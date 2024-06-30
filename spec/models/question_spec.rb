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
    it 'converts the each question to a CSV' do
      Question.create(input: "etc", label: "test")
      Question.create(input: "more", label: "tests")
      
      CSV.generate(headers: true, col_sep: ";") do |csv|
        Question.to_csv(csv)
      end
    end
  end

  describe '#to_csv' do
    it 'converts the question to a CSV' do
      question = Question.create(input: "more", label: "tests")

      CSV.generate(headers: true, col_sep: ";") do |csv|
        question.to_csv(csv, 0)
      end
    end
  end

  describe '#send_csv' do
    it 'sends the parameters to the csv' do
      question = Question.create(input: "more", label: "tests")

      CSV.generate(headers: true, col_sep: ";") do |csv|
        question.send_csv(csv, 0)

        expect(csv.headers).to eq(["1. tests", "Sem respostas fornecidas."])
      end
    end   
  end

end
