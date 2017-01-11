# frozen_string_literal: true
# AIC Lakeshore staging server
set :user, 'rbrun'
server 'aicdams07-tmp.artic.edu', user: 'rbrun', roles: %w(web app db)
