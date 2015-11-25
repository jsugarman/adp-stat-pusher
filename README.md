### ADP Stat Pusher

This simple Sinatra application enables the pushing of manually gathered statistics related to the Advocate
Defendence Payments application up to the Goverment Performance platform.

# Setup

You will need to add a .secrets.yml file for the relevant keys and uuids of the various
endpoints

you will also need the following environment variables. The key values themselves must be obtained from Performance platforms team. The UUIDs can obtained from Joel Sugarman, in the first instance. The UUIDS were one-off generated using ```SecureRandom.uuid``` to uniquely.

```
export TRANSACTIONS_BY_CHANNEL_KEY=''
export COMPLETION_RATE_KEY=''
export PAPER_COUNT_UUID=''
export DIGITAL_COUNT_UUID=''
export COMPLETE_COUNT_UUID=''
export START_COUNT_UUID=''

```

# Usage

Enter the manually gather statistics