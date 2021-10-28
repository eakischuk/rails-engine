# README
This is an e-commerce API that allows access to merchant and item information including revenue and items sold statistics for merchants. Available endpoints are detailed below. Currently, this API is not deployed, but can be run on localhost:3000 and accessed via Postman. 

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
      - returns a list of all items with optional per_page and page params
      - default per_page = 20
    - post /items
      - create a new item
      - required attributes: name, description, unit_price (Float), valid merchant id
    - get /items/:id
      - return a single item by ID
    - patch /items/:id
      - updates a single item by ID
    - delete /items/:id
      - destroys a single item by ID
      - destroys any invoices with only that item on them
    - get /items/:item_id/merchant
      - returns merchant information for an item by item ID
    - get /items/find_all
      - returns all items for given search criteria
        - search criteria can be by item name
        - search criteria can be by min and/or max price
        - search criteria cannot include both name and price parameters
  - Revenue endpoints
    - get /revenue
      - returns revenue for the entire system with required start and end parameters for a date range
        - date parameters must be given in `YYYY-MM-DD` format
        - will return all revenue for all-ecompassing date range
        - will return 0 for a date range without revenue
    - get /revenue/merchants?quantity=
      - returns list of merchants ordered by revenue descending 
      - requires quantity param for how many merchants will be returned
    - get /revenue/merchants/:id
      - returns revenue for a single merchant by ID
 
