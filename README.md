# RoR BlackJack

A basic, ajax blackjack game like this one  
- http://www.247blackjack.com/  

## Setup
After cloning the repository, start up the app with:
```
docker-compose up -d
```

If this is the first time, you need to set up the db:  
```
docker-compose run --rm app rake db:create db:migrate
```
