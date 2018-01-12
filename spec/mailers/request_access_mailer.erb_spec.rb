# frozen_string_literal: true
require 'rails_helper'

describe RequestAccessMailer, type: :mailer do
  let(:presenter) { double }
  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    allow(presenter).to receive(:depositor).and_return("Kim Cole")
    allow(presenter).to receive(:depositor_first_name).and_return("Kim")
    allow(presenter).to receive(:requester_pretty_name).and_return("Joe Bob")
    allow(presenter).to receive(:requester).and_return("Joe")
    allow(presenter).to receive(:requester_email).and_return("user1@artic.edu")
    allow(presenter).to receive(:title_or_label).and_return("Sample")
    allow(presenter).to receive(:id).and_return("1234")
    allow(presenter).to receive(:uid).and_return("SI-1234")
    allow(presenter).to receive(:depositor_email).and_return("kcole@artic.edu")

    described_class.request_access(presenter).deliver_now
  end

  it 'sends an email' do
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'renders the receiver email' do
    expect(ActionMailer::Base.deliveries.first.to.first).to eq("kcole@artic.edu")
  end

  it 'sets the subject to the correct subject' do
    expect(ActionMailer::Base.deliveries.first.subject).to eq("LAKE Access request for asset SI-1234")
  end

  it 'contains links to the asset' do
    expect(ActionMailer::Base.deliveries.first.encoded).to include('<a href="http://localhost:3000/concern/generic_works/1234/edit#share">Approve request</a>')
    expect(ActionMailer::Base.deliveries.first.encoded).to include('<a href="http://localhost:3000/concern/generic_works/1234">Review asset</a>')
  end

  it 'contains asset uid, pref_label, and requester full name' do
    expect(ActionMailer::Base.deliveries.first.encoded).to include('SI-1234')
    expect(ActionMailer::Base.deliveries.first.encoded).to include('Sample')
    expect(ActionMailer::Base.deliveries.first.encoded).to include('Joe Bob')
  end

  it 'renders the sender email' do
    expect(ActionMailer::Base.deliveries.first.from).to eq(["user1@artic.edu"])
  end

  after do
    ActionMailer::Base.deliveries.clear
  end
end
