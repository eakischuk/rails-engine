# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
 `ruby 2.7.2`
 `rails 5.2.6`
* System dependencies
  - Testing Gems
    - `pry`
    - `rspec-rails`
    - `factory_bot_rails`
    - `faker`
    - `shoulda-matchers`
    - `simplecov`
    - `capybara`
* Configuration
  - fork and/or clone this repo
  - `bundle install`
* Database creation and initialization
  - `rails db:{drop,create,migrate,seed}`
  - `rails db:schema:dump`
* How to run the test suite
  - `bundle exec rspec`
* Endpoints
  - all endpoints begin with '/api/v1'
  - Merchants endpoints
    - get /merchants
      - returns a list of all merchants with option per_page and page params
      - default per_page = 20
    - get /merchants/:id
      - returns one merchant by ID
    - get /merchants/:merchant_id/items
      - returns a list of items for given merchant by merchant ID
    - get /merchants/most_items?quantity=
      - returns list of merchants ordered by most items sold
      - quantity of merchants to be returned must be defined by user
    - get /merchants/find?name=
      - returns a single merchant that best matches a given name query
  - Items endpoints
    - get /items
      - 
    

* Deployment instructions

* ...
