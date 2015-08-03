module WorksControllerBehavior
  extend ActiveSupport::Concern

  included do
    include Sufia::Controller
    include Breadcrumbs

    layout "sufia-one-column"

    before_action :authenticate_user!, except: [:index, :show]
    before_action :has_access?, except: [:show]
    before_action :set_work, only: [:update, :edit, :show]
    before_action :build_breadcrumbs

    # TODO
    #load_and_authorize_resource except: [:index, :show]
  end

  def index
    redirect_to catalog_index_path(params.except(:controller, :action).merge(f: { Solrizer.solr_name("aic_type", :facetable) => ["Work"] }))
  end

  def new
    @work = Work.new
    @form = edit_form_class.new(@work)
  end

  def edit
    @form = edit_form_class.new(@work)
  end

  def create
    @work = Work.new
    if update_work
      flash[:notice] = "A new work was created"
      redirect_to edit_work_path(@work)
    else
      flash[:error] = @work.errors.full_messages.join(",")
      redirect_to new_work_path
    end
  end

  def update
    if update_work
      flash[:notice] = "The update was successful"
    else
      flash[:error] = "The update was unsuccessful"
    end
    redirect_to edit_work_path(@work)
  end

  def show
    @presenter = presenter
  end

  private

    def update_work
      attributes = edit_form_class.model_attributes(params["work"])
      @work.attributes = attributes
      @work.save
    end

    def set_work
      @work = Work.find(params[:id])
    end
    
    def presenter
      presenter_class.new(@work)
    end

end
