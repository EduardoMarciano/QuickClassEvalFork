# == Form
#
# Defines and stores current and previous disciplines' forms of the application.
#
# Attributes:
#   id: Integer, primary key
#   template_id: Integer, foreign key
#   questions_id: Array[Integer], foreign key
#   discipline_id: Integer, foreign key
#   
# Usage:
#   Template.create()
#   Discipline.create()
#   form = Form.create(template_id: 1, discipline_id: 1)
#   form.save
#
class Form < ApplicationRecord
  belongs_to :template, optional: true
  has_many :questions, as: :formlike
  belongs_to :discipline
  before_create :import_template_data

  ##
  # Parses each form to the given line on the csv.
  #
  # Parameters:
  #   csv - CSV
  #   line - Array
  #
  # Returns:
  #   String
  #
  # Usage:
  #   CSV.generate(headers: true, col_sep: "; ") do |csv|
  #     Form.to_csv(csv, [])
  #   end
  #
  def self.to_csv(csv, line)
    all.each do |form|
      form.to_csv(csv, line)
    end
  end

  ##
  # Transforms the form to a CSV line and calls its questions' csv formatting method. 
  #
  # Parameters:
  #   csv - CSV
  #   line - Array
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   form = Form.create()
  #   CSV.generate(headers: true, col_sep: "; ") do |csv|
  #     form.to_csv(csv, [])
  #   end
  #
  def to_csv(csv, line)
    line << template_id.to_s
    questions.to_csv(csv, line.dup, self)
  end

  private

  ##
  # Returns form's questions if the form exists.
  #
  # Returns:
  #   Array
  #
  # Usage:
  #   form = Form.create()
  #   form.import_template_data
  #
  def import_template_data
    copy_questions unless template.nil?
  end

  ##
  # Copies the questions from the template.
  #
  # Returns:
  #   questions - Array
  #
  # Usage:
  #   form = Form.create()
  #   form.copy_questions
  #
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

  ##
  # Gets the questions' parameters
  #
  # Returns:
  #   Hash
  #
  def question_params(question)
    {
      formlike: self,
      label: question.label,
      description: question.description,
      format: question.format
    }
  end
end
