export BEFTA_OAUTH2_ACCESS_TOKEN_TYPE_OF_XUIWEBAPP=OIDC
export BEFTA_OAUTH2_CLIENT_ID_OF_XUIWEBAPP=xuiwebapp
export BEFTA_OAUTH2_CLIENT_SECRET_OF_XUIWEBAPP=OOOOOOOOOOOOOOOO
export BEFTA_OAUTH2_REDIRECT_URI_OF_XUIWEBAPP=http://localhost:3333/oauth2/callback
export BEFTA_OAUTH2_SCOPE_VARIABLES_OF_XUIWEBAPP="profile openid roles"
export BEFTA_S2S_CLIENT_ID_OF_XUI_WEBAPP=xui_webapp
export BEFTA_S2S_CLIENT_SECRET_OF_XUI_WEBAPP=OOOOOOOOOOOOOOOO
export BEFTA_S2S_CLIENT_ID_OF_CCD_DATA=ccd_data
export BEFTA_S2S_CLIENT_SECRET_OF_CCD_DATA=AAAAAAAAAAAAAAAB
export CCD_BEFTA_MASTER_SOLICITOR_4_PWD=Pa55word11
export CCD_BEFTA_PUI_CAA_1_PWD=Pa55word11
export CCD_BEFTA_SOLICITOR_4_PWD=Pa55word11
export TEST_URL=http://localhost:4454

export BEFTA_IDAM_CAA_USERNAME=master.caa@gmail.com
export BEFTA_IDAM_CAA_PASSWORD=Pa55word11

export HMC_DB_USERNAME=hmc
export HMC_DB_PASSWORD=hmc

WIREMOCK_STUB_SERVICE_NAME=http://localhost:4459

export HMC_SERVICE_BUS_CONNECTION_STRING=Endpoint=sb://hmc-servicebus-demo.servicebus.windows.net/\;SharedAccessKeyName=SendAndListenSharedAccessKey\;SharedAccessKey=COKUIio903Dz8FMzOq5jtKecHPgVej9copS9N7gKL/U=;
export HMC_SERVICE_BUS_TOPIC=hmc-to-cft-demo;
export HMC_SERVICE_BUS_SUBSCRIPTION=hmc-subs-to-cft-demo;

export HMC_QUEUE_CONNECTION_STRING=Endpoint=sb://hmc-servicebus-demo.servicebus.windows.net/\;SharedAccessKeyName=ListenSharedAccessKey\;SharedAccessKey=OOdA/C2XcjeEFRjjiUVh4U8qKVDKLflbahqboHI/zoo=\;EntityPath=hmc-from-hmi-demo;
export HMC_SERVICE_BUS_QUEUE=hmc-from-hmi-demo;
export HMC_SERVICE_BUS_CONNECTION_STRING=Endpoint=sb://hmc-servicebus-demo.servicebus.windows.net/\;SharedAccessKeyName=policy\;SharedAccessKey=lMlwtV5e+IhDW4RyXDLJRLypkYOzzyQTsp9LrGKKbrE=\;EntityPath=test-topic;
export HMC_SERVICE_BUS_TOPIC=test-topic