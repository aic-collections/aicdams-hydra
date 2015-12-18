require 'rails_helper'

describe ListItemsController do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before { sign_in user }
  let(:list) { List.create }

  describe "#new" do
    context "with a html request" do
      before { get :new, list_id: list }
      its(:response) { is_expected.to be_redirect }
    end
    context "with an xhr request" do
      before { xhr :get, :new, list_id: list }
      its(:response) { is_expected.to be_success }
    end
  end

  describe "#create" do
    let(:new_list_item) { { pref_label: "New Thing", description: ["Description of new thing."] } }
    before { xhr :post, :create, list_id: list, list_item: new_list_item }
    it "adds a new list item to the list" do
      list.reload
      expect(list.members.first.pref_label).to eq("New Thing")
    end
    context "with a bogus list id" do
      before { xhr :post, :create, list_id: "bogus", list_item: new_list_item }
      it "redirects to the list page" do
        expect(response).to be_redirect
        expect(flash[:error]).to eq("Unable to find list with id bogus")
      end
    end
  end

  context "with an existing list and list item" do
    before { list.members << ListItem.create(pref_label: "Foo") }

    describe "#edit" do
      context "with a html request" do
        before { get :edit, list_id: list, id: list.members.first }
        its(:response) { is_expected.to be_redirect }
      end
      context "with an xhr request" do
        before { xhr :get, :edit, list_id: list, id: list.members.first }
        its(:response) { is_expected.to be_success }
      end
    end

    describe "#update" do
      before { xhr :patch, :update, list_id: list, id: list.members.first, list_item: { description: ["a description"] } }
      subject { list.reload.members.first }
      its(:description) { is_expected.to contain_exactly("a description") }
    end

    context "when adding another item with the same label" do
      let(:duplicate_item) { { pref_label: "Foo", description: ["Duplicate list item"] } }
      before { xhr :post, :create, list_id: list, list_item: duplicate_item }
      subject { flash[:error] }
      it { is_expected.to contain_exactly("Members must be unique") }
    end
  end

  describe "#destroy" do
    let(:list_item) { ListItem.create(pref_label: "Delete me") }
    before { list.members << list_item }
    it "removes and deletes a member from the list" do
      delete :destroy, list_id: list, id: list_item
      expect(ListItem.exists?(list_item.id)).to be false
    end
  end
end
