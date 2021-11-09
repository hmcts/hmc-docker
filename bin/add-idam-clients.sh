#!/usr/bin/env bash

set -eu

dir=$(dirname ${0})

${dir}/utils/idam-create-service.sh "xuiwebapp" "xuiwebapp" "OOOOOOOOOOOOOOOO" "http://localhost:3333/oauth2/callback" "false" "profile openid roles manage-user create-user"

${dir}/utils/idam-create-service.sh "hmc_cft_hearing_service" "hmc_cft_hearing_service" "hmc_cft_hearing_service_secret" "http://localhost:4561/oauth2redirect" "false" "profile openid roles search-user"
