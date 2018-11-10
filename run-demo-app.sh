#!/bin/bash

docker-compose exec hydra hydra --endpoint http://hydra:4445 \
  clients delete \
    test-client

docker-compose exec hydra hydra --endpoint http://hydra:4445 \
  clients create \
    --id test-client \
    --secret test-secret \
    --response-types code,id_token \
    --grant-types refresh_token,authorization_code,implicit \
    --scope openid,offline,email,profile \
    --callbacks https://10.168.142.1:4446/callback,https://10.168.142.1:5000/v3/OS-FEDERATION/identity_providers/myidp/protocols/openid/auth,https://10.168.142.1:5000/v3/auth/OS-FEDERATION/websso/openid/redirect

docker-compose exec hydra hydra --endpoint http://hydra:4445 \
  clients delete \
    openstack

docker-compose exec hydra hydra --endpoint http://hydra:4445 \
  clients create \
    --id openstack \
    --secret openstackopenstack \
    --response-types code,id_token \
    --grant-types refresh_token,authorization_code \
    --scope openid,offline \
    --callbacks https://10.168.142.1:4446/callback

docker-compose exec hydra hydra --skip-tls-verify --endpoint http://hydra:4445 \
  token user \
    --scope openid,offline \
    --client-id test-client \
    --client-secret test-secret \
    --auth-url https://10.168.142.1:4444/oauth2/auth \
    --token-url https://10.168.142.1:4444/oauth2/token \
    --redirect https://10.168.142.1:4446/callback
