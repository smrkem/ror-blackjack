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

I think I'd honestly prefer to make this serverless using something like dynamodb - it seems like a really good use case for digging into nosql and api patterns. But making this in rails has a few advantages as well:
- up and running extrememly quickly
- easy to test
- an opportunity to learn more about EC2 instance configuration, deployment and management.

The big disadvantages are that it'll probably cost more - a lot more than hosting a serverless solution.


I want to build this totally TDD, and use docker locally.


### The 'Activity' resource  
The api will revolve around the concept of Activities. An example of an activity would be "50 min exercise at 1:35pm Nov 15, 2017 where my average heart rate was 140".
