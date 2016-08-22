# frozen_string_literal: true
# AIC Lakeshore production server
set :user, 'rbrun'
server 'lakeshore.artic.edu', user: 'rbrun', roles: %w(web app db)
