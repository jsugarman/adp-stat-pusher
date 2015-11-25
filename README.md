### ADP Stat Pusher

This simple Sinatra application enables the pushing of manually gathered statistics related to the Advocate
Defendence Payments application up to the Goverment Performance platform.

# Setup

You will need to add a .secrets.yml file for the relevant keys and uuids of the various
endpoints

you will also need the following environment variables.

```
  export ADP_STAT_PUSHER_USERNAME='<username>'
  export ADP_STAT_PUSHER_PASSWORD='<password>'


# Usage
Enter the manually gather statistics