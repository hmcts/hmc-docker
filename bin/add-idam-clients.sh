#!/usr/bin/env bash

set -eu

dir=$(dirname ${0})

${dir}/utils/idam-create-service.sh "xuiwebapp" "xuiwebapp" "OOOOOOOOOOOOOOOO" "http://localhost:3333/oauth2/callback" "false" "profile openid roles manage-user create-user"
