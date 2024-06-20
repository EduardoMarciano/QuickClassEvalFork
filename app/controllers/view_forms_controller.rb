class ViewFormsController < ApplicationController
  def index
    @disciplines = Discipline.all
    @class_members = ClassMember.all
  end
end
