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
echo "  $APPNAME help"
echo "     Show this help"
