# Cinema Matcher Rails Appserver

This is the backend application for the Cinema Matcher application

## RVM
Although not required, it is strongly recommended that you install [RVM](https://rvm.io/rvm/install).

## Versions
* Ruby 2.6.7
* Rails 6.1.3


## Installation

### AWS

This application uses AWS so create an IAM user with access to SQS and S3 and add the credentials to the
credentials and as environment variables in the following manner:

```
AWS_REGION=us-east-2
AWS_ACCESS_KEY_ID='aws_access_key_id'
AWS_SECRET_ACCESS_KEY='aws_access_key_id'
```

### SMTP

In order to take advantage of the mailer, you need to create the config file `config/smtp.yml`. Here is an example config file.
```
development:
  address: smtp.gmail.com
  authentication: !ruby/symbol plain
  domain: gmail.com
  enable_starttls_auto: true
  password: <%= Rails.application.credentials.mailer_password %>
  port: 587
  user_name: mailer@gmail.com
```

### Setup
Run `rake setup:all` after handling the above tasks. It will check if you have done the above things.
