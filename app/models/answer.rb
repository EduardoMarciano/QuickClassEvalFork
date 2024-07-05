# Represents an answer given by a user to a question in the application.
#
# Answers belong to a user and optionally to a question.
#
# Example usage:
#   answer = Answer.new(content: 'This is my answer', user: current_user)
#   answer.question = Question.find(1)
#   answer.save
#
class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question, optional: true
end
