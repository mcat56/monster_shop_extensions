# Monster Shop

Monster Shop is an online shopping site through which users can buy, sell, and review items. One can interact with Monster Shop as a visitor, user, merchant, or admin. Visitors are afforded basic access while registered users can access greater functionality. Special types of users such as merchants and admins have greater privileges than regular users and have greater control over orders. Monster Shop allows users to register and login using a secure password and provides statistics regarding previous customers' purchases.

## Getting Started

To run this application, visit this site through its heroku link. To view this application's code, clone this repository and run `rails db:create` then `rails db:migrate` and `rails db:seed` in your terminal.

### Installing

As long as one has Rails installed, run rails s to interact with the application in a local development environment. In some cases, one might want to reset the database. For example, if you've added several items and would like to clear them all and return the original development environment, run `rails db:{drop,create,migrate,seed}` to reset the database in your local development environment.

## Running the tests

To run the tests for this application, run `rspec` in your terminal.

### Purpose of Tests

The tests for this application are broken into models and features. The model tests test all logic that resides in models while the features tests test everything that has to do with user interactivity including a page's path and content.

## Deployment

To deploy this application on heroku, run the following commands in your terminal:

`heroku create`
`git remote -v` (to check that a heroku remote has been successfully created)
`git push heroku master`

## Author

**Mary Lang** - https://github.com/mcat56
