source $APPDIR/../lib/helper.subr

with_temp_and_region

echo "# Checks OGW client subnet compatability"
echo "# OK    = no restictions in usage"
echo "# WARN  = warning, multiple subnets use the same route"
echo "# ERROR = error, either no default route or no main routing table"

SUBNETS=$TMP/subnets.json
ROUTES=$TMP/routing.json

function subnet_cidr() {
  cat $SUBNETS | jq -r -c '.Subnets[] | if .SubnetId == "'$1'" then .CidrBlock else empty end'
}

function print_list() {
  PRINT=$TMP/print.txt
  for SUBNET in $2; do
    CIDR=$(subnet_cidr $SUBNET)
    echo -e "$1\t$SUBNET\t$CIDR" >> $PRINT
  done
  if [[ -f $PRINT ]]; then
    sort -k 3 $PRINT
  fi
}

for VPC_ID in $@; do

printf "# Compatability of client subnets in $VPC_ID "

aws ec2 describe-subnets --filters '{"Name":"vpc-id","Values":["'$VPC_ID'"]}' >  $SUBNETS || exit 2
printf "."

aws ec2 describe-route-tables --filters `cat $SUBNETS | \
  jq -c '{ Name: "association.subnet-id", Values: [.Subnets[].SubnetId] } '` > $ROUTES || exit 3
printf ".\n"

OK_SUBNET_LIST=`cat $ROUTES | jq -r -c '.RouteTables[] | if (.Associations | length) == 1 and .Routes[].DestinationCidrBlock == "0.0.0.0/0" then .Associations[].SubnetId else empty end'`
WARN_SUBNET_LIST=`cat $ROUTES | jq -r -c '.RouteTables[] | if (.Associations | length) > 1 and .Routes[].DestinationCidrBlock == "0.0.0.0/0" then .Associations[].SubnetId else empty end'`

ERR_SUBNET_LIST=""
for SUBNET in `cat $SUBNETS | jq -r -c '.Subnets[] | .SubnetId'`; do
  if [[ !("$OK_SUBNET_LIST $WARN_SUBNET_LIST" =~ $SUBNET) ]]; then
    ERR_SUBNET_LIST+="$SUBNET "
  fi
done


print_list "OK" "$OK_SUBNET_LIST"
print_list "WARN" "$WARN_SUBNET_LIST"
print_list "ERROR" "$ERR_SUBNET_LIST"

done