# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf

printf "Checking git  (>= 2.8) ...\n  "
git version
printf "Checking awscli (>= 1.10) ...\n  "
aws --version
printf "Checking jq (>= 1.5) ...\n  "
jq --version
