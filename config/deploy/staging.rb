# frozen_string_literal: true
# AIC Lakeshore staging server
set :user, 'rbrun'
server 'aicdamstest07.artic.edu', user: 'rbrun', roles: %w(web app db)
