#!/opt/homebrew/bin/bash
## clean all project
ps -ef  | grep -i java | grep -i ccoms | awk '{print $2}' |xargs kill -9