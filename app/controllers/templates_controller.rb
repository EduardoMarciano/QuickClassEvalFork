# frozen_string_literal: true

# Controls routes for templates. Only administrators may see or edit templates.
class TemplatesController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  ##
  # Displays all templates.
  #
  # @return [void]
  def index
    return redirect_to root_path unless user_authenticated && admin_user?

    @templates = Template.all
  end

  ##
  # Creates a new template.
  #
  # @return [void]
  def new
    return redirect_to root_path unless user_authenticated && admin_user?

    @template = Template.new
  end

  ##
  # Shows details of a specific template.
  #
  # @param [Integer] id The ID of the template.
  # @return [void]
  def show
    return redirect_to root_path unless user_authenticated && admin_user?

    @template = Template.find(params[:id])
  end

  ##
  # Creates a new template based on user input.
  #
  # @param [Integer] id The ID of the template to be removed.
  # @return [void]
  def create
    return redirect_to root_path unless user_authenticated && admin_user?

    if params[:questions].nil? || (params[:questions][0]["label"] == "" || params[:questions][0]["description"] == "")
      flash[:error] = 'Crie pelo menos uma questão válida.'
      redirect_to '/templates/new'
    else
      template = Template.create
      params[:questions].each do |question|
        question = question.permit(:label, :description, :type, :format)
        question[:description] = nil unless question[:description].present?
        new_question(template, question)
      end
      flash[:success] = 'Modelo de formulário criado com sucesso'
      redirect_to templates_path
    end
  end

  ##
  # Destroys a template.
  #
  # @return [void]
  def destroy
    return redirect_to root_path unless user_authenticated && admin_user?

    params.permit(:authenticity_token, :_method, :controller, :action, :id)
    return unless params[:_method] == 'delete' && params[:action] == 'destroy' && params[:controller] == 'templates'

    Template.find(params[:id]).destroy!
    redirect_to templates_path
  end

  ##
  # Displays a page for sending a form to students of a discipline.
  #
  # @return [void]
  def edit_send
    return redirect_to root_path unless user_authenticated && admin_user?

    @disciplines = Discipline.all
    @templates = Template.all
    render 'templates/send/index'
  end

  ##
  # Gives students of disciplines access to a form copied from the given template.
  #
  # @return [void]
  def send_out_forms
    return redirect_to root_path unless user_authenticated && admin_user?

    send_form_to_disciplines(params[:discipline_ids], params[:template_id]) unless params[:discipline_ids].nil?

    form_send_result_flash
    redirect_to manager_path
  end

  private

  ##
  # Displays a flash message based on form sending results.
  #
  # @return [void]
  def form_send_result_flash
    if !params[:discipline_ids] || params[:discipline_ids].empty?
      flash[:error] = 'Nenhuma disciplina foi selecionada para envio'
    else
      flash[:success] = 'Formulários enviados com sucesso'
    end
  end

  ##
  # Sends a form to disciplines.
  #
  # @param [Array<Integer>] discipline_ids IDs of disciplines.
  # @param [Integer] template_id ID of the template.
  # @return [void]
  def send_form_to_disciplines(discipline_ids, template_id)
    discipline_ids.each do |discipline_id|
      Form.create!(template: Template.find(template_id), discipline: Discipline.find(discipline_id))
    end
  end

  ##
  # Creates a new question for the template.
  #
  # @param [Template] template The template.
  # @param [Hash] question A hash containing question details.
  # @return [Object] The created question.
  def new_question(template, question)
    case question[:type]
    when 'MultipleChoiceQuestion'
      return unless question[:format].present?

      created = MultipleChoiceQuestion.create(formlike: template,
                                              label: question[:label],
                                              description: question[:description],
                                              format: question[:format])
    when 'TextInputQuestion'
      created = TextInputQuestion.create(formlike: template, label: question[:label],
                                         description: question[:description])
    else
      flash[:error] = 'Tipo de pergunta inválido'
      redirect_to templates_path
    end
    created
  end
end
