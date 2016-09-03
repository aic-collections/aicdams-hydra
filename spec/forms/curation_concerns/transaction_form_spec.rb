# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::TransactionForm do
  let(:user1)       { create(:user1) }
  let(:transaction) { Transaction.new }
  let(:ability)     { Ability.new(user1) }
  let(:form)        { described_class.new(transaction, ability) }

  subject { form }

  it_behaves_like "a form for a Citi resource"
end
