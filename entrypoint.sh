#!/bin/bash

set -e

redis-server $REDIS_CONF_LOCATION

$@