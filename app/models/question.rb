# Represents a question associated with a form or another form-like entity in the application.
#
# Questions can belong to various form-like entities through polymorphic association,
# and can have multiple answers associated with them.
#
# @!attribute [r] formlike
#   @return [Form, Template, Discipline] the form-like entity this question belongs to
# @!attribute answers
#   @return [Array<Answer>] the answers associated with this question
#
class Question < ApplicationRecord
  belongs_to :formlike, polymorphic: true
  has_many :answers

  # Determines if the question expects an input answer.
  #
  # @return [Boolean] always returns false for a generic question
  def input?
    false
  end

  # Determines if the question is objective.
  #
  # @return [Boolean] returns true if the question is not an input and has an answer, false otherwise
  def objective?
    !input? && !self[:answer].nil?
  end

  # Checks if a given answer is valid for the question.
  #
  # @param _ [String] answer the answer to be checked (unused)
  # @return [Boolean] always returns true for a generic question
  def valid_answer?(_)
    true
  end

  # Exports all questions to a CSV format.
  #
  # @param csv [CSV] the CSV object to which the questions will be written
  # @param line [Array<String>] the line of CSV data
  # @param form [Form] the form to which the questions belong
  def self.to_csv(csv, line, form)
    all.each_with_index do |question, index|
      question.to_csv(csv, index, line, form)
    end
  end

  # Exports the question to a CSV format.
  #
  # @param csv [CSV] the CSV object to which the question will be written
  # @param index [Integer] the index of the question in the form
  # @param line [Array<String>] the line of CSV data
  # @param form [Form] the form to which the question belongs
  def to_csv(csv, index, line, form)
    answers = self.answers.pluck(:answer).join(", ")
    answers_line = (answers == "") ? "" : answers

    line << "#{label}" << answers

    csv << line if index + 1 == form.questions.length
  end


end
