### ADP Stat Pusher

This simple Sinatra application enables the pushing of manually gathered statistics related to the Advocate
Defendence Payments application up to the Goverment Performance platform.

Heroku app available at https://adp-stat-pusher.herokuapp.com/

# Setup

You will need the following environment variables in your local environment. The API key values themselves must be obtained from Performance platforms team. The UUIDs can obtained from Joel Sugarman, in the first instance. The UUIDS were one-off generated using ```SecureRandom.uuid```. The basic authentication details can be set as preferred.

```
export ADP_STAT_PUSHER_USERNAME=''
export ADP_STAT_PUSHER_PASSWORD=''
export TRANSACTIONS_BY_CHANNEL_KEY=''
export COMPLETION_RATE_KEY=''
export PAPER_COUNT_UUID=''
export DIGITAL_COUNT_UUID=''
export COMPLETE_COUNT_UUID=''
export START_COUNT_UUID=''
```

# Usage

Login when prompted and enter the manually gathered statistics into the appropriate fields and hit send. You will be directed to a page displaying a summary of the response from Performance platforms.
