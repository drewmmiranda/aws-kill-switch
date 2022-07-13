# Setup

# git config --global user.email "you@example.com"
# git config --global user.name "Your Name"
# git config credential.helper store

##########

# change to git project dir
cd /root/git/aws-kill-switch

# remove any untracked or unstaged changes, force a known good working state
git reset --hard

# get any changes
git pull

# write epoch time to text file
date +%s > /root/git/aws-kill-switch/src/graylog-aws.log

# stage changes
git add .

# commit
git commit -m "commit"

# push
git push
