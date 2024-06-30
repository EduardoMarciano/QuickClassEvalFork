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

  def self.to_csv(csv)
    all.each_with_index do |question, index|
      question.to_csv(csv, index)
    end
  end

  def to_csv(csv, index)
    send_csv(csv, index)
  end

  def send_csv(csv, index)
    answers_empty = self.answers.empty? ? ['Sem respostas fornecidas.'] : []
    answers = self.answers.pluck(:answer)

    csv << ["#{index + 1}. #{label}"] + answers_empty + answers
  end

end
