# Handles form-related requests within the application.
class FormsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  ##
  # Displays a list of forms.
  #
  # If the user is an admin, all forms are returned. Otherwise, only forms that
  # the user can answer are displayed.
  #
  # @return [void]
  def index
    # TODO: If student, only return forms they can answer
    return redirect_to root_path unless user_authenticated && admin_user?

    @forms = Form.all
  end

  ##
  # Shows details of a specific form.
  #
  # @param [Integer] id The ID of the form.
  # @return [void]
  def show
    form = Form.find(params[:id])
    return redirect_to root_path unless user_authenticated && user_belongs_to?(form.discipline)

    @answers = {}
    @form = form
    @form.questions.each do |question|
      @answers[question.id] = Answer.where(user_id: logged_user.id, question_id: question.id).first
    end
  end

  ##
  # Creates a new form.
  #
  # @return [void]
  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  ##
  # Updates a form.
  #
  # @param [Hash] questions A hash of question IDs and answers.
  # @return [void]
  def update
    return redirect_to root_path unless user_belongs_to?(Form.find(params[:id]).discipline)

    answer(params[:questions]) unless params[:questions].nil?

    flash[:success] = 'Formulário respondido com sucesso'
    redirect_to evaluations_path
  end

  private

  ##
  # Answers questions for a form.
  #
  # @param [Hash] questions A hash of question IDs and answers.
  # @return [Hash] A hash of valid answers.
  def answer(questions)
    return false unless questions.respond_to?(:each)

    valids = {}
    questions.each do |question_id, answer|
      question = Question.find(question_id)
      next unless question.valid_answer?(answer)

      Answer.create! question:, answer:, user: logged_user
    end
    valids
  end
end
