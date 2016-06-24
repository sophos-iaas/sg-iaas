SUBNETS=$TMP/subnets.json
ROUTES=$TMP/routing.json
TABLE=$TMP/routing-table.json
NETINTERFACES=$TMP/network-interfaces.json
REPLACES=$TMP/replace.sed

printf "Fetch AWS information "
# fetch all VPC subnets
aws ec2 describe-subnets --filters '{"Name":"vpc-id","Values":["'$VPC_ID'"]}' > $SUBNETS || exit 2
printf "."

# find all routing tables assosicated with the subnets
aws ec2 describe-route-tables --filters `cat $SUBNETS | jq -c '{ Name: "association.subnet-id", Values: [.Subnets[].SubnetId] } '` > $ROUTES || exit 3
cat $ROUTES | jq '[.RouteTables[] | { Subnets: [.Associations[].SubnetId], RoutesTo: (.Routes[] | if(.DestinationCidrBlock == "0.0.0.0/0") then .NetworkInterfaceId else empty end) } | if (.RoutesTo == null) then empty else . end]' > $TABLE
printf "."

# find all network interfaces for the routeing tables
aws ec2 describe-network-interfaces --network-interface-ids `cat $TABLE | jq -r '.[].RoutesTo'` > $NETINTERFACES || exit 4
printf "."

# have sed commands to replace the subnet by it's cidr
cat $SUBNETS | jq -r -c '.Subnets[] | "s|" + .SubnetId + "|" +.CidrBlock + "|g;"' > $REPLACES
cat $NETINTERFACES | jq -r -c '.NetworkInterfaces[] | "s|" + .NetworkInterfaceId + "|" +.PrivateIpAddress + "|g;"' >> $REPLACES

printf "\n"
sed -f $REPLACES $TABLE | jq -r '.[] | .Subnets[] + " -> " + .RoutesTo ' | sort
