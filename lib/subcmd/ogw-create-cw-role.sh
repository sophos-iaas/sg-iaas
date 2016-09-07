# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.
# Authors: Georg Fleig

source $LIB_DIR/helper.subr

with_temp_and_region

CWROLE="EC2ActionsAccess"

# We do not use get-role first to check for the existence of the role as this
# would require additional rights that we might not have.
printf "Trying to create IAM role \"$CWROLE\"."
ROLE_CREATE_ERR=$(aws iam create-role --role-name $CWROLE --path="/actions/" --assume-role-policy-document='{"Version":"2012-10-17","Statement":[{"Action":"sts:AssumeRole","Principal":{"Service":"swf.amazonaws.com"},"Effect":"Allow","Sid":""}]}' 2>&1 >/dev/null)

if [[ $ROLE_CREATE_ERR =~ "EntityAlreadyExists" ]]; then
  printf "\nRole already exists, nothing to do here.\n"
  exit 0
elif [[ $ROLE_CREATE_ERR != "" ]]; then
  printf "$ROLE_CREATE_ERR\n"
  exit 2
fi

printf " Done\nAttaching policy."
aws iam attach-role-policy --role-name $CWROLE --policy-arn="arn:aws:iam::aws:policy/CloudWatchActionsEC2Access" > /dev/null
if [[ $? ]]; then
  printf " Done\n"
else
  printf " Failed! Will delete the empty role.\n"
  aws iam delete-role --role-name $CWROLE > /dev/null || exit 3
  exit 4
fi
