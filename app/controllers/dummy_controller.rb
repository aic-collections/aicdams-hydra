# frozen_string_literal: true
class DummyController < ApplicationController
  layout "bare"

  def login_confirm
    render text: "meow"
  end
end
