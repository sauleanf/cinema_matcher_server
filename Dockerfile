FROM ruby:2.6.7

WORKDIR /cinema_matcher
RUN apt update && apt install -y curl software-properties-common

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . .

EXPOSE 3000

CMD ["rake", "db:setup"]
CMD ["rake", "db:migrate"]
CMD ["rails", "s", "-b", "0.0.0.0"]
