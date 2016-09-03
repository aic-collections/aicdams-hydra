# frozen_string_literal: true
require 'rails_helper'

describe CurationConcerns::PlaceForm do
  let(:user1)   { create(:user1) }
  let(:place)   { Place.new }
  let(:ability) { Ability.new(user1) }
  let(:form)    { described_class.new(place, ability) }

  subject { form }

  it_behaves_like "a form for a Citi resource"
end
