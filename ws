#!/bin/bash
workspaceNumber=$1
dirName=$2
projectName=`echo $dirName | cut -d- -f2`
i3-msg "workspace number $workspaceNumber"

if [ "$2" == "browser" ] ; then
    i3-msg "exec google-chrome"
elif [ "$2" == "slack" ] ; then
    i3-msg "exec slack"
else
    wd="$HOME/git/$dirName"

    term="gnome-terminal"
    echo ". ~/.bashrc ; vim -c \"OpenSession! $dirName\"" > /tmp/ws-main
    echo ". ~/.bashrc ; yarn run watch" > /tmp/ws-top
    echo ". ~/.bashrc ; yarn run dev" > /tmp/ws-mid
    echo ". ~/.bashrc ; cowsay $projectName" > /tmp/ws-bot

    # Layout
    cat ~/util/workspace.template.json | sed "s/%PROJECT%/$projectName/" > /tmp/ws-layout
    echo i3-msg "workspace $workspaceNumber; append_layout /tmp/ws-layout"
    i3-msg "workspace $workspaceNumber:$projectName; append_layout /tmp/ws-layout"

    # Command to open a new term
    newTerm="exec $term --working-directory=$wd --hide-menubar"

    i3-msg "$newTerm --role="$projectName:editor" -- /bin/bash --init-file /tmp/ws-main"
    i3-msg "$newTerm --role="$projectName:watch" -- /bin/bash --init-file /tmp/ws-top"
    i3-msg "$newTerm --role="$projectName:dev" -- /bin/bash --init-file /tmp/ws-mid"
    i3-msg "$newTerm --role="$projectName:util" -- /bin/bash --init-file /tmp/ws-bot"
fi
