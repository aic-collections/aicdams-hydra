# frozen_string_literal: true
class CurationConcerns::TransactionsController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CitiResourceBehavior
  self.curation_concern_type = Transaction
  self.show_presenter = TransactionPresenter
end
