#!/usr/bin/env bash
#
mkdir -p logs/

case "$1" in
  22:00)
    bash jobs/projects_git_daemon.sh >> logs/projects_git_daemon.log 2>&1
    ;;

  *)
    echo "$(date) - unkown params: $1"
    ;;
esac
