class ListItemsController < ApplicationController
  before_action :find_list, only: [:create, :destroy]

  def new
    @item = ListItem.new
    @form = ListItemEditForm.new(@item)
    if request.xhr?
      render partial: "new_modal"
    else
      redirect_to list_path(params[:list_id])
    end
  end

  def edit
    @form = ListItemEditForm.new(ListItem.find(params[:id]))
    if request.xhr?
      render partial: "edit_modal"
    else
      redirect_to list_path(params[:list_id])
    end
  end

  def update
    item = ListItem.find(params[:id])
    item.attributes = sanitized_attributes
    if item.save
      flash[:notice] = "The item was updated"
    else
      flash[:error] = "An error occurred and the list was not updated"
    end
    redirect_to list_path(params[:list_id])
  end

  def create
    @list.add_item(ListItem.create(sanitized_attributes))
    if @list.errors
      flash[:error] = @list.errors.full_messages
    else
      flash[:notice] = "Successfully added item to list"
    end
    respond_to do |format|
      format.html { redirect_to list_path(params[:list_id]) }
      format.js   { render nothing: true }
    end
  end

  def destroy
    item = ListItem.find(params[:id])
    @list.members.delete(item)
    item.destroy
    redirect_to list_path(params[:list_id])
  end

  private

    def find_list
      if List.exists?(params[:list_id])
        @list = List.find(params[:list_id])
      else
        flash[:error] = "Unable to find list with id #{params[:list_id]}"
        redirect_to lists_path
      end
    end

    def sanitized_attributes
      ListItemEditForm.model_attributes(params[:list_item])
    end
end
