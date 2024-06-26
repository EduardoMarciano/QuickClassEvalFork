# frozen_string_literal: true

# Controls routes for templates. Only administrators may see or edit templates.
class TemplatesController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  def index
    return redirect_to root_path unless user_authenticated && admin_user?

    @templates = Template.all
  end

  def show
    return redirect_to root_path unless user_authenticated && admin_user?

    @template = Template.find(params[:id])
  end

  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
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

    params.permit(:authenticity_token, :commit, :template_id, discipline_ids: [])

    if params[:discipline_ids].nil?
      flash[:error] = 'Nenhuma disciplina foi selecionada para envio'
      return redirect_to manager_path
    end

    params[:discipline_ids].each do |discipline_id|
      Form.create! template: Template.find(params[:template_id]), discipline: Discipline.find(discipline_id)
    end

    flash[:success] = 'Formulários enviados com sucesso'
    redirect_to manager_path
  end
end
