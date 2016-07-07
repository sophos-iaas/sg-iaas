source $APPDIR/../lib/helper.subr

echo "Commands:"
echo "  $APPNAME update"
echo "     Update the sg-iaas package"
echo "  $APPNAME verify"
echo "     Verify the installation"
if utm; then
echo "  $APPNAME setup"
echo "     Install the awscli until using pip"
fi
echo "  $APPNAME ogw-routes <vpc-id>"
echo "     Check the instance routes set in the vpc"
echo "  $APPNAME ogw-compat <vpc-id>"
echo "     Check the compatibility of the subnets in the vpc"
echo "  $APPNAME help"
echo "     Show this help"
