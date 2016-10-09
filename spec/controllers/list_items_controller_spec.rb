# frozen_string_literal: true
require 'rails_helper'

describe ListItemsController do
  let(:list_item) { create(:list_item) }
  let(:list) { create(:list, members: [list_item]) }

  include_context "authenticated admin user"

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
    context "with a valid list id" do
      before { xhr :post, :create, list_id: list, list_item: new_list_item }
      it "adds a new list item to the list" do
        list.reload
        expect(list.members.map(&:pref_label)).to include("New Thing")
      end
    end
    context "with a bogus list id" do
      before { xhr :post, :create, list_id: "bogus", list_item: new_list_item }
      its(:response) { is_expected.to be_not_found }
    end
    context "with a user without edit rights" do
      include_context "authenticated saml user"
      before { xhr :post, :create, list_id: list, list_item: new_list_item }
      its(:response) { is_expected.to be_not_found }
    end
  end

  context "with an existing list and list item" do
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
      subject { list.reload.members.map(&:description) }
      it { is_expected.to contain_exactly(["a description"], []) }
    end

    context "when adding another item with the same label" do
      let(:duplicate_item) { { pref_label: list_item.pref_label } }
      before { xhr :post, :create, list_id: list, list_item: duplicate_item }
      subject { flash[:error] }
      it { is_expected.to contain_exactly("Members must be unique") }
    end
  end

  describe "#destroy" do
    it "removes and deletes a member from the list" do
      delete :destroy, list_id: list, id: list_item
      expect(ListItem.exists?(list_item.id)).to be false
    end
  end
end
