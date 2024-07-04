class EvaluationsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern
  def index
    if user_authenticated
      @disciplines_info = Discipline.all_disciplines_with_eval_info(logged_user.email, admin_user?)
      render 'index'
    else
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def disciplines
    if user_authenticated
      @disciplines_info = Discipline.all_disciplines_info(logged_user.email, admin_user?)
      render 'disciplines'
    else
      redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end

  def show
    discipline = Discipline.find(params[:id])

    respond_to do |format|
      format_do(format, discipline)
    end
  end

  def format_do(format, discipline)
    format.html do
      redirect_to evaluations_path
    end

    format.csv do
      send_data discipline.to_csv_single, filename: "#{discipline.name}.csv"
    end
  end
end
