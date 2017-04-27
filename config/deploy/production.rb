# frozen_string_literal: true
# AIC Lakeshore production server
set :user, 'rbrun'
server 'aicdams07.artic.edu', user: 'rbrun', roles: %w(web app db)
