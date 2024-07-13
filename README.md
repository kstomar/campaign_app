# README

## Ruby and Rails version
  - ruby-3.0.0
  - Rails 7.1.3.4

## Dependencies
  - `bundle install`

## Configuration
- Set database username, password in 'config/database.yml':
  - Create and setup the database:
    `bundle exec rails db:create`
    `bundle exec rails db:migrate` OR you can use just `bundle exec rails db:setup`

## Run
  - Start server
    `bundle exec rails server`
  - And now you can access the apis with the URL http://localhost:3000


## Postman Collection
  - You can test our API endpoints using the Postman collection.
    `https://api.postman.com/collections/9303429-dbc149eb-5cd7-4e66-8c2d-af701ea60493`