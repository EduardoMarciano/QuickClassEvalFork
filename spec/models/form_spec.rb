# Teste unitario para model Form
require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Form, type: :model do
  describe 'associations' do
    it 'belongs to template' do
      association = Form.reflect_on_association(:template)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many questions as formlike' do
      association = Form.reflect_on_association(:questions)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:as]).to eq(:formlike)
    end

    it 'belongs to discipline' do
      association = Form.reflect_on_association(:discipline)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'callbacks' do
    it 'calls import_template_data before create' do
      form = Form.new(template: Template.create, discipline: Discipline.create)
      allow(form).to receive(:import_template_data)
      form.save
      expect(form).to have_received(:import_template_data)
    end
  end

  describe '#import_template_data' do
    let(:template) { Template.create }
    let(:form) { Form.new(template:, discipline: Discipline.create) }

    context 'when template is nil' do
      it 'does not import template data' do
        form.template = nil
        form.save
        expect(form.questions).to be_empty
      end
    end

    context 'when template has questions' do
      before do
        @mc_question = MultipleChoiceQuestion.create(
          formlike: template,
          label: 'MCQ Label',
          description: 'MCQ Description',
          format: 'multiple_choice'
        )
        @text_question = TextInputQuestion.create(
          formlike: template,
          label: 'Text Input Label',
          description: 'Text Input Description',
          format: 'text_input'
        )
        @default_question = Question.create(
          formlike: template,
          label: 'Default Question Label',
          description: 'Default Question Description',
          format: 'default'
        )
      end

      it 'imports questions from the template' do
        form.save
        expect(form.questions.size).to eq(3)
        expect(form.questions.map(&:type).compact).to contain_exactly('MultipleChoiceQuestion', 'TextInputQuestion')
      end

      it 'sets the correct attributes for imported questions' do
        form.save
        imported_mc_question = form.questions.find { |q| q.type == 'MultipleChoiceQuestion' }
        expect(imported_mc_question.label).to eq(@mc_question.label)
        expect(imported_mc_question.description).to eq(@mc_question.description)
        expect(imported_mc_question.format).to eq(@mc_question.format)

        imported_text_question = form.questions.find { |q| q.type == 'TextInputQuestion' }
        expect(imported_text_question.label).to eq(@text_question.label)
        expect(imported_text_question.description).to eq(@text_question.description)
        expect(imported_text_question.format).to eq(@text_question.format)

        imported_default_question = form.questions.find { |q| q.type.nil? }
        expect(imported_default_question.label).to eq(@default_question.label)
        expect(imported_default_question.description).to eq(@default_question.description)
        expect(imported_default_question.format).to eq(@default_question.format)
      end
    end
  end
end
