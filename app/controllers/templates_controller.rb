# frozen_string_literal: true

# Controls routes for templates. Only administrators may see or edit templates.
class TemplatesController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  def index
    return redirect_to root_path unless user_authenticated && admin_user?

    @templates = Template.all
  end

  def new
    return redirect_to root_path unless user_authenticated && admin_user?

    @template = Template.new
  end

  def show
    return redirect_to root_path unless user_authenticated && admin_user?

    @template = Template.find(params[:id])
  end

  def create
    return redirect_to root_path unless user_authenticated && admin_user?

    template = Template.create
    params[:questions].each do |question|
      question = question.permit(:label, :description, :type, :format)
      question[:description] = nil unless question[:description] != ''
      new_question(template, question)
    end
    flash[:success] = 'Modelo de formulário criado com sucesso'
    redirect_to templates_path
  end

  def update
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  def destroy
    return redirect_to root_path unless user_authenticated && admin_user?

    params.permit(:authenticity_token, :_method, :controller, :action, :id)
    return unless params[:_method] == 'delete' && params[:action] == 'destroy' && params[:controller] == 'templates'

    Template.find(params[:id]).delete
    redirect_to templates_path
  end

  # GET: Page for sending a form to students of a discipline
  def edit_send
    return redirect_to root_path unless user_authenticated && admin_user?

    @disciplines = Discipline.all
    @templates = Template.all
    render 'templates/send/index'
  end

  # POST: Gives students of disciplines access to a form copied from the given template
  def send_out_forms
    return redirect_to root_path unless user_authenticated && admin_user?

    params[:discipline_ids].each do |discipline_id|
      Form.create! template: Template.find(params[:template_id]), discipline: Discipline.find(discipline_id)
    end

    flash[:success] = 'Formulários enviados com sucesso' unless params[:discipline_ids].nil?
    redirect_to manager_path
  end

  private

  def new_question(template, question)
    case question[:type]
    when 'MultipleChoiceQuestion'
      return unless question[:format].present?

      created = MultipleChoiceQuestion.create formlike: template,
                                              label: question[:label],
                                              description: question[:description],
                                              format: question[:format]
    when 'TextInputQuestion'
      created = TextInputQuestion.create formlike: template, label: question[:label],
                                         description: question[:description]
    else
      flash[:error] = 'Tipo de pergunta inválido'
      redirect_to templates_path
    end
    created
  end
end
