#!/bin/bash

cd /var/app

# Check server type
if [ "$APP_ENV_TYPE" == "TESTING" ]; then
    chmod a+x /var/app/deploy/run-tests.sh
    /var/app/deploy/run-tests.sh
else
    cp /var/app/deploy/supervisor_conf.d/start_sidekiq_queues.conf /etc/supervisor/conf.d/
    supervisord -c /etc/supervisor/supervisord.conf
    # Run passenger
    NUM_PROCESSES=2
    bundle exec passenger start -a 0.0.0.0 -p 8080 --max-pool-size ${NUM_PROCESSES} --log-file '/dev/stdout'
fi
