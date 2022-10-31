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

## Installing

### Setup `aws-kill-switch-poll.sh` on the NON aws VM (e.g. on prem VM)

Prerequisites:

* Git
* Git config completed with user.email and user.name
    * `git config --global user.email "you@example.com"`
    * `git config --global user.name "Your Name"`
* Git credential helper configured to 'store'
    * `git config --system credential.helper store`
* Github Personal Access Token
    * Via Github / Settings / Developer Settings / Personal access tokens
        * This is required in order to authenticate using an account with MFA/2FA enabled

Instructions: 

1. Create directory `/root/git`
2. Git Clone this repo to this directory, which will create `/root/git/aws-kill-switch`
    * `git clone https://....`
    * NOTE: run `git push` at at least once to save the credential
3. Copy `aws-kill-switch-poll.sh`
    * from `/root/git/aws-kill-switch/src`
    * to `/root/git`
        * NOTE: this is done to ensure the script isn't changed while running and to avoid accidentally breaking the script
4. Add a line to crontab
    * `*/5 * * * * /root/git/aws-kill-switch-poll.sh >/dev/null 2>&1`
        * NOTE: this runs once every 5 minutes, but can be customzied to suite your needs
5. At this point `graylog-aws.log` will be updated each time the cron job executes

### Setup `deadman.sh` on AWS instance

1. Copy `deadman.sh` to /root
2. Make executable via `chmod +x deadman.sh`
3. Add to crontab
