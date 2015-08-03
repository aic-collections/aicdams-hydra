require 'rails_helper'

describe WorksController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
  end

  let(:work) { Work.create }

  let(:asset) do
    GenericFile.create.tap do |f|
      f.title = ["Asset in a work"]
      f.apply_depositor_metadata user
      f.save
    end
  end

  describe "#new" do
    before { get :new }
    subject { response }
    it { is_expected.to be_successful }    
  end

  describe "#edit" do
    before { get :edit, id: work }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#create" do
    before { post :create, work: { gallery_location: ["East wing"], asset_ids: [asset.id] } }
    specify "a new work with assets" do
      expect(response).to be_redirect
      expect(flash[:notice]).to eql "A new work was created"
    end
  end

  describe "#update" do
    before { post :update, id: work, work: { artist_display: ["Picasso"] } }
    specify do
      expect(response).to be_redirect
      expect(work.reload.artist_display).to eql ["Picasso"]
    end
  end

  describe "#show" do
    before { get :show, id: work }
    subject { response }
    it { is_expected.to be_successful }
  end

  describe "#index" do
    before { get :index }
    subject { response }
    it { is_expected.to be_redirect }
  end

end
