class Question < ApplicationRecord
  belongs_to :formlike, polymorphic: true
  has_many :answers

  def input?
    false
  end

  def objective?
    !input? && !self[:answer].nil?
  end

  def valid_answer?(_)
    true
  end

  def self.to_csv(csv, line, form)
    all.each_with_index do |question, index|
      question.to_csv(csv, index, line, form)
    end
  end

  def to_csv(csv, index, line, form)
    answers = self.answers.pluck(:answer).join(", ")
    answers_line = (answers == "") ? "" : answers

    line << "#{label}" << answers

    csv << line if index + 1 == form.questions.length
  end

end
