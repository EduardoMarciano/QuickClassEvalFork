class Form < ApplicationRecord
  belongs_to :template
  has_many :questions, as: :formlike
  belongs_to :discipline
  before_create :import_template_data

  def self.to_csv(csv)
    all.each do |form|
      form.to_csv(csv)
    end
  end

  def to_csv(csv)
    send_csv(csv)
    self.questions.to_csv(csv)
  end

  def send_csv(csv)
    csv << ["Formulário #{self.id}"]
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
