class Form < ApplicationRecord
  belongs_to :template, optional: true
  has_many :questions, as: :formlike
  belongs_to :discipline
  before_create :import_template_data

  def self.to_csv(csv, line)
    all.each do |form|
      form.to_csv(csv, line.dup)
    end
  end

  def to_csv(csv, line)
    line << "#{template_id}"
    self.questions.to_csv(csv, line.dup, self)
  end

  private

  def import_template_data
    return if template.nil?

    template.questions.each do |question|
      question_params = {
        formlike: self,
        label: question.label,
        description: question.description,
        format: question.format
      }
      questions << case question.type
                   when 'MultipleChoiceQuestion'
                     MultipleChoiceQuestion.new(question_params)
                   when 'TextInputQuestion'
                     TextInputQuestion.new(question_params)
                   else # Usually a 'Question' class
                     Question.new(question_params)
                   end
    end
  end
end
