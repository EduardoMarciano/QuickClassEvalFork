# frozen_string_literal: true

# Represents a multiple choice question.
#
# This class inherits from `Question` and provides specific behavior for
# questions that have multiple choice answers.
#
class MultipleChoiceQuestion < Question

  # Checks if the question requires an input.
  #
  # @return [Boolean] always returns true for multiple choice questions
  def input?
    true
  end

  # Retrieves the available options for the multiple choice question.
  #
  # The options are stored in the `format` attribute as a string, with each
  # option separated by a pipe ('|') character.
  #
  # @return [Array<String>] an array of options or an empty array if no options are available
  def options
    format = self[:format]
    return [] if format.nil?

    format.split '|'
  end

  # Checks if a given input is a valid answer for the multiple choice question.
  #
  # A valid answer is one that is included in the list of options.
  #
  # @param input [String] the answer to validate
  # @return [Boolean] true if the answer is valid, false otherwise
  def valid_answer?(input)
    options.include?(input)
  end
end
