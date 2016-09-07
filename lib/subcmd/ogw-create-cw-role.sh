# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Georg Fleig

source $LIB_DIR/helper.subr

with_temp_and_region

CW_ROLE="EC2ActionsAccess"
POLICY_ARN="arn:aws:iam::aws:policy/CloudWatchActionsEC2Access"

function create_role() {
  aws iam create-role --role-name="$1" --path="/actions/" \
                      --assume-role-policy-document='{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "swf.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }' 2>&1 >/dev/null
}

function delete_role() {
  aws iam delete-role --role-name="$1" > /dev/null
}

function attach_policy_to_role() {
  aws iam attach-role-policy --role-name="$1" \
                             --policy-arn="$2" > /dev/null
}

# We do not use get-role first to check for the existence of the role as this
# would require additional rights that we might not have.
printf "Trying to create IAM role \"$CW_ROLE\": "
ROLE_CREATE_ERR=$(create_role $CW_ROLE)

if [[ $ROLE_CREATE_ERR =~ "EntityAlreadyExists" ]]; then
  printf "Role already exists, will not touch it.\n"
  exit 0
elif [[ $ROLE_CREATE_ERR != "" ]]; then
  printf "$ROLE_CREATE_ERR\n"
  exit 2
fi

printf "done\nAttaching policy: "
if ! attach_policy_to_role $CW_ROLE $POLICY_ARN; then
  printf "Failed! Will delete the empty role.\n"
  delete_role $CW_ROLE || exit 3
  exit 4
fi

printf "done\n"
