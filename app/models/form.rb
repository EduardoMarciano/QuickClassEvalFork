class Form < ApplicationRecord
  belongs_to :template, optional: true
  has_many :questions, as: :formlike
  belongs_to :discipline
  before_create :import_template_data

  def self.to_csv(csv, line)
    all.each do |form|
      form.to_csv(csv, line)
    end
  end

  def to_csv(csv, line)
    line << template_id.to_s
    questions.to_csv(csv, line.dup, self)
  end

  private

  def import_template_data
    copy_questions unless template.nil?
  end

  # Copies the questions from the tempalte
  def copy_questions
    template.questions.each do |question|
      questions << case question.type
                   when 'MultipleChoiceQuestion'
                     MultipleChoiceQuestion.new(question_params(question))
                   when 'TextInputQuestion'
                     TextInputQuestion.new(question_params(question))
                   else # Usually a 'Question' class
                     Question.new(question_params(question))
                   end
    end
  end

  def question_params(question)
    {
      formlike: self,
      label: question.label,
      description: question.description,
      format: question.format
    }
  end
end
