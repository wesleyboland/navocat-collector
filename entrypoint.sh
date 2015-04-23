#!/bin/bash

set -e

redis-server appendonly yes &

$@