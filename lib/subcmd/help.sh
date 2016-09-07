# Copyright 2016 Sophos Technology GmbH. All rights reserved.
# See the LICENSE.txt file for details.
# Authors: Vincent Landgraf, Georg Fleig

source $LIB_DIR/helper.subr

echo "Commands:"
if ! utm; then
echo "  $APPNAME update"
echo "     Update the sg-iaas package"
echo "  $APPNAME verify"
echo "     Verify the installation"
fi
echo "  $APPNAME ogw-routes <vpc-id>"
echo "     Check the instance routes set in the vpc"
echo "  $APPNAME ogw-compat <vpc-id>"
echo "     Check the compatibility of the subnets in the vpc"
echo "  $APPNAME ogw-create-cw-role"
echo "     Creates IAM role to allow CloudWatch to restart OGW instances"
echo "  $APPNAME help"
echo "     Show this help"
