# ORIGIN TEST

This application was developed using Docker, Docker Compose, SQLite3 and Ruby on Rails in it's version:
* Docker version 19.03.8, build afacb8b
* docker-compose version 1.25.5, build 8a1c60f6
* ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]
* Rails 6.0.3.1
* SQLite 3.27.2 2019-02-25

## Third party plugins
For testing:
* RSpec
* json-schema
* simplecov
* shoulda-matchers

For application build:
* JWT
* simple_command

## Assumptions
The application was developed assuming that it will be used directly by users.
Users will be able to register using email and password.
When users use the application providing their data, the application will return an analysis of their risk profile.
The application will persist the user data, as well as the risk profile generated and also the score that generated the risk profile.

## The Codebase
The code base is available at [GitHub](https://github.com/eks/origin)
At the time of the test delivery, there are 6 branches. Are they:
* feature/data_persistence
* feature/jwt
* feature/risk_evaluation
* feature/simple_solution
* master
* staging

The `master` branch contains the lates developed solution and it was deployed to [Heroku](https://origin-eks.herokuapp.com).

## Running the APP locally

To configure the application and make it ready for use, just execute these commands:
```sh
$ cd origin-test
$ docker-compose --build
$ docker-compose run --rm web bundle exec rails db:create db:migrate db:seed
$ docker-compose up
```
These commands will configure the application inside a linux container, create the database and data tables, insert a user's dummy data and leave the application running, ready to receive requests.

## Sending requests
After application is up and running it's possible to send requests.
It is possible to use the user's dummy data created in the application configuration step to make the first requests.
First it is necessary to authenticate the user. Using cURL:
```sh
$ curl -X POST -H "Content-Type: application/json" -d '{"email":"example@mail.com","password":"123123123"}' http://localhost:3000/authenticate
```

Using the token returned by the previous request, we will make a POST request passing a payload:
```sh
$ curl -X POST http://localhost:3000/risk_evaluations \
  -H "Authorization: RESPONSE_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{ "age": 35, "dependents": 2, "house": { "ownership_status": "owned" }, "income": 0, "marital_status": "married", "risk_questions": [0, 1, 0], "vehicle": { "year": 2018 } }' -i
```

The response to the previously executed request will be a JSON with the risk profile for the sent data.
The `-i` flag will show the HEADERS of the response and the `Location` header will be present. Location is setted with the path to the risk profile created in the last reuqest to be accessed at any time later.

### Sign Up
The application have an endpoint to sign up new users. To do so, a POST request is needed, like so:
```sh
$ curl -X POST http://localhost:3000/sign_up -H "Content-Type: application/json" \
  -d '{"email": "new-mail@example.com", "password": "123123123", "password_confirmation": "123123123"}'
```

### Using on Heroku
As the application is available on [Heroku](https://origin-eks.herokuapp.com), it can be used exchanging `http://localhost:3000` for `https://origin-eks.herokuapp.com` in all cURL request commands.

## Running tests locally
To run tests
```sh
$ docker-compose run --rm web rspec
```

The application indludes test coverage plugin named SimpleCov.
SimpleCov generates a html file after RSpec was executed that can be opened in brower. This file is located inside project path at coverage folder.
It can be easily opened in MacOS:
```sh
$ cd origin-test
$ open coverage/index.html
```

Or in Linux:
```sh
$ cd origin-test
$ xdg-open coverage/index.html
```
OR
```sh
$ cd origin-test
$ google-chrome coverage/index.html
```

