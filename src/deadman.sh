# Get timestamp of last ping
lastping=$(curl https://raw.githubusercontent.com/drewmmiranda/aws-kill-switch/master/src/graylog-aws.log)

# get diff
curping=$(date +%s)

diff=$(($curping-$lastping))

maxdiff=1500

if [ $lastping -gt 0 ]
then
    echo "Current Ping: $curping"
    echo "Last Ping: $lastping"
    echo "Diff: $diff sec"
    echo "Max Diff Allowed: $maxdiff sec"

    if [ $diff -gt $maxdiff ]
    then
        echo "Diff $diff is greater than allowed max $maxdiff"
        echo "Shutting Down Machine..."
        shutdown -h now
    else
        echo "Check OK."
    fi
else
    echo "ERROR, invalid lastping value"
fi
