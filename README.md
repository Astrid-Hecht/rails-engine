# Rails Engine Light

## Project Summary
This was a 4 day solo project assigned during my time at the Turing School of Software and Design. It was meant to teach the importance and methods of API creation, exposure, and non-RESTful endpoints, as well as reinforcment on MVC design principles. Rails Engine Lite also heavily focused on giving us the tools to expect, handle, and test any possible edge cases; my personal implimentation of the project tried to pushed that goal as far as possible. 

Besides the data set & schema, everything was built from scratch.

___

### Installation and set-up
 * Fork and clone this repository
 * Run `bundle install`
 * Run `rake db:{drop,create,migrate,seed}` to set up databases from the included dataset
 * Run `rails s`
 And you should be good to go!
 
 Routes can be found with the command `rails routes` or by viewing the route file. They generally follow the format of `/api/v1/<object>/<id or action>` where `<object>` is either `merchants` or `items`
 
 ### Testing
 * After set up, run `bundle exec rspec spec`, `bundle exec rspec spec/models`, or `bundle exec rspec spec/requests` to check test coverage
 * Additional coverage details can be found by running `open coverage/index.html`
 
 ### Other info
 The project kickoff page can be found here: https://backend.turing.edu/module3/projects/rails_engine_lite/
 The above page also has two links to download additional test suites for postman that this project was written to pass. If you'd like to test it   further, feel free to import them into postman and run them after starting the rails server.

This README would normally document whatever steps are necessary to get the
application up and running.

