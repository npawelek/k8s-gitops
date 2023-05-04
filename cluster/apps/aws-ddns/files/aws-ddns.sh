#!/usr/bin/env sh

set -o nounset
set -o errexit

cd /app
terraform init -upgrade
terraform plan -out terraform.plan
terraform apply -auto-approve terraform.plan
