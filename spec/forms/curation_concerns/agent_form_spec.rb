# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::AgentForm do
  let(:user1)   { create(:user1) }
  let(:agent)   { Agent.new }
  let(:ability) { Ability.new(user1) }
  let(:form)    { described_class.new(agent, ability) }

  subject { form }

  it_behaves_like "a form for a Citi resource"
end
