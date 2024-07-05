# frozen_string_literal: true

# A question with textual imput.
#
class TextInputQuestion < Question

  # @!group Instance Methods

  # Indicates that this question expects textual input.
  #
  # @return [Boolean] Always returns true.
  def input?
    true
  end
end
