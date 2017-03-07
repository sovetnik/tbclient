# README

## Authentication client

Client app for [authentication service](https://github.com/sovetnik/tbauth),
When user try access /member page, which requires authentication, app generates RSA keys pair, remember Private key in redis, and redirect user to auth service with Public key. After return user ap tries to authenticate user by token, which can be decoded from `token` param by Private key. Authenticated user get new session each time, but redis store token by session.id. Redis store keys and tokens by limited time.


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.4

* System dependencies
docker

* Configuration
create `dev.env` from `sample.env`run 
```bash
docker-compose up --build
```

* Database creation
```bash
docker-compose run app rails db:create db:migrate
```
