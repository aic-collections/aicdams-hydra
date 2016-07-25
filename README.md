# Art Institute of Chicago - LAKEshore

[![Build Status](https://travis-ci.org/aic-collections/aicdams-lakeshore.svg?branch=master)](https://travis-ci.org/aic-collections/aicdams-lakeshore)

## Local Setup

To prepare the development environment, ensure that all of Sufia's requirements are met.
See [Getting Started](https://github.com/projecthydra/sufia#getting-started)

Clone the repository

    git clone https://github.com/aic-collections/aicdams-lakeshore
    cd aicdams-lakeshore
    bundle install
    bundle exec rake db:migrate

Startup Solr and Fedora using the included wrappers

    bundle exec solr_wrapper
    bundle exec fcrepo_wrapper

Once they are running, you will need to load sample users and resources

    bundle exec rake dev:prep

Before you can use the web application, you will need to mimic the Shibboleth environment. See the
[wiki page](https://github.com/aic-collections/aicdams-lakeshore/wiki/Faking-Shibboleth-Authentication)
about how to do that.

Then start the web application

    bundle exec rails server

And visit http://localhost:3000

## Testing

The test environment will use the same Fedora instance, but you will need to start another Solr instance
for testing

    bundle exec solr_wrapper --config config/solr_wrapper_test.yml

Then you can run the entire suite

    bundle exec rspec

Or individual tests

    bundle exec rspec path/to/spec.rb

## Deployment

### Development Server

A cloned repository is deployed to the development server and run in development mode.
This is not the usual way Capistrano is used, but is done so to enable development work directly on the
server. By default, it will update to the latest commit in the develop branch.

    bundle exec cap dev repo:update
    bundle exec cap dev repo:config

If this a is new deployment, use `bundle exec cap dev repo:update`

### Test Server

Deployed via Capistrano in the normal fashion:

    bundle exec cap test deploy

### Passenger

Passenger is installed and deployed the same for all environments:

    bundle exec cap dev passenger:install
    bundle exec cap dev passenger:config
