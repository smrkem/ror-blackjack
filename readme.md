# TrackMe  
### A Rails5 API with a basic React front end

*As a user - I want to be able to input the time, duration and average heart rate after I exercise*  

***  

I'll be making 2 independent apps:
- TrackMe API  
  A Rails5 api, dockerized for development and depoyed to AWS EC2
- Daily Activity
  A set of React 'widgets' for quickly authenticating and interacting with resources from the TrackMe API.
    - quickly enter an activity ("Exercise", "duration", "avg. heart rate")
    - get my current 'status' of activities

## TrackMe API  
This is the API that handles all the data.

Following https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one  



I think I'd honestly prefer to make this serverless using something like dynamodb - it seems like a really good use case for digging into nosql and api patterns. But making this in rails has a few advantages as well:
- up and running extrememly quickly
- easy to test
- an opportunity to learn more about EC2 instance configuration, deployment and management.

The big disadvantages are that it'll probably cost more - a lot more than hosting a serverless solution.


I want to build this totally TDD, and use docker locally.


### The 'Activity' resource  
The api will revolve around the concept of Activities. An example of an activity would be "50 min exercise at 1:35pm Nov 15, 2017 where my average heart rate was 140". So datetime, duration and average_heart_rate - nice and simple.

I *could* make an very straightforward "Exercise" model and I'm done. And that's exactly what I'll do. I have no idea what this app will ultimately become, and I know this model isn't going to extend very well to accomodate other types of activities. But I'm going to trust in the agile concepts of MVP and letting user experience drive the design.  

So TrackMe API v0.1.0 will have 2 resources:
- users
- exercises

### Creating a new project  
I'm following my basic, boilerplate dockerized rails workflow - there's a repo with basic instructions here:  
- https://github.com/smrkem/rails-docker


My current project folder structure looks like so:
```
├── docker-compose.yml
├── trackmeapi
│   └── Dockerfile
└── webapp
```
I have a folder for the front-end webapp and another for trackmeapi. Currently it only has my boilerplate Dockerfile for a rails 5, ruby 2.3 app and before using that I need to create the app and Gemfile.

I can create a new ruby 2.3 container and share that folder as a volume.  
```
$ docker run --rm -it -v $PWD/trackmeapi:/trackme ruby:2.3.1 bash
```
and then from inside the container:
```
# gem install rails
# cd /trackme
# rails new . --api -T -B
```
(`.` to build in the current folder, `--api` to only use Rails API features, `-T` to skip-tests since I'll be using RSpec, `-B` to skip the bundle install)
