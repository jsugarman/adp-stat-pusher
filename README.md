# ADP Stat Pusher

This simple Sinatra application enables the pushing of manually gathered statistics related to the Advocate
Defendence Payments application up to the Goverment Performance platform.

Heroku app available at https://adp-stat-pusher.herokuapp.com/

### Setup

```
cd <to-desired-parent-folder>
git clone <name-of-this-repo>
```

You will also need the following environment variables in your local environment. The API key values themselves must be obtained from Performance platforms team. The basic authentication details can be set as preferred.

```
export ADP_STAT_PUSHER_USERNAME=''
export ADP_STAT_PUSHER_PASSWORD=''
export TRANSACTIONS_BY_CHANNEL_KEY=''
export COMPLETION_RATE_KEY=''
```
### Run locally

To run the app locally:

```
cd adp-stat-pusher
shotgun
```

then in browser:

```
url: http://localhost:9393/
```

### Usage

Login when prompted and enter the manually gathered statistics into the appropriate fields and hit send. You will be directed to a page displaying a summary of the response from Performance platforms.

Data passed can currently be viewed as JSON using the URL(s) below:

```
https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/<endpoint>
```

e.g. currently:

  https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/transactions-by-channel

  https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/completion-rate

### TODO

  - extend rspec/test suite
  - deployment: on MoJ platforms - ticket in SPOC trello board https://trello.com/c/5U3ZEa9m
  - frontend: scss/sass and moj internal template application
  - pre-populate Digital, Complete and Start statistics with those from ADP app
  - mailer to confirm send mail and confirm when data has been set
