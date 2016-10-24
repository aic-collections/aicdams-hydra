# frozen_string_literal: true
class UsersController < ApplicationController
  include Sufia::UsersControllerBehavior

  def index
    @users = user_list
    respond_to do |format|
      format.html
      format.json { render json: @users.to_json }
    end
  end

  private

    def user_list
      if params[:uq].blank?
        User.all.references(:trophies).order(sort_value).page(params[:page]).per(10)
      elsif params[:q].present? && params[:q] == 'all'
        AICUser.search(params[:uq])
      else
        AICUser.active_users(params[:uq])
      end
    end
end
