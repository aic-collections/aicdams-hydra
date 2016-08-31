# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::ExhibitionForm do
  let(:user1)      { create(:user1) }
  let(:exhibition) { Exhibition.new }
  let(:ability)    { Ability.new(user1) }
  let(:form)       { described_class.new(exhibition, ability) }

  subject { form }

  it_behaves_like "a form for a Citi resource"
end
