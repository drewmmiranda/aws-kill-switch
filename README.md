# aws-kill-switch
Proof of concept, dead man switch to auto shutoff AWS instance(s)

## What is this?

This is a rudimentary tool that provides a "deadman's switch" functionality to running AWS instances.
Its designed as a failsafe to shutdown AWS instances and prevent excessive costs.

## What does this do and how does it work?

This tool comprises 2 parts:

1. aws-kill-switch-poll.sh
2. deadman.sh

NOTE: these are not terribly well named.

### aws-kill-switch-poll.sh

This script is designed to run on my home lab (which does not incur any cost, beyond electricity).

This script:

1. Runs on a linux VM via a cron job
2. Write the out of `date +%s` to a text file (unix epoch time, number of seconds that have elapsed since January 1, 1970 (midnight UTC/GMT))
3. Commit and push file to this git repo

### deadman.sh

This script is designed to run on an AWS instance (VM).

1. Runs via cron job
2. Fetches contents of file that above script commits to
3. Compares fetched value with current unix epoch time
4. IF difference (in seconds) is greater than configured max, shutdown instance (`shutdown -h now`)
