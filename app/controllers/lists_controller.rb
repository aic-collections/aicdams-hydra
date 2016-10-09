# frozen_string_literal: true
class ListsController < ApplicationController
  include Breadcrumbs

  with_themed_layout '1_column'
  before_action :load_resource, except: [:index]
  before_action :build_breadcrumbs

  def index
    @lists = sorted_lists.map { |l| ListPresenter.new(l) }
  end

  def show
    @presenter = ListPresenter.new(resource)
  end

  def edit
    @form = ListEditForm.new(resource)
  end

  def update
    resource.attributes = sanitized_attributes
    if resource.save
      flash[:notice] = "The item was updated"
    else
      flash[:error] = "An error occurred and the list was not updated"
    end
    redirect_to edit_list_path(params[:id])
  end

  private

    def load_resource
      redirect_to(lists_path) unless current_user.can?(:edit, resource)
    end

    def resource
      @resource ||= List.find(params[:id])
    end

    def sanitized_attributes
      ListEditForm.model_attributes(params[:list])
    end

    def sorted_lists
      List.all.sort { |a, b| a.pref_label <=> b.pref_label }
    end
end
