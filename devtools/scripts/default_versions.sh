#!/bin/bash
##########################################################################################
# Licensed Materials - Property of IBM
# (c) Copyright IBM Corporation 2019, 2022. All Rights Reserved.
#
# Note to U.S. Government Users Restricted Rights:
# Use, duplication or disclosure restricted by GSA ADP Schedule
# Contract with IBM Corp.
##########################################################################################

function printCommand() {
    echo "# $@"
    $@
    echo ""
}
printCommand jq --version
printCommand yq --version
printCommand kubectl version --output=yaml --client
printCommand buildctl --version
printCommand helm version --client
printCommand ibmcloud -version
printCommand ibmcloud plugin list
printCommand ibmcloud dev --version
printCommand oc version
echo "# zip"
zip --version | head -n 2
echo ""
echo "# unzip"
unzip -v | head -n 1
echo ""
printCommand git --version
echo "# curl"
curl --version | head -n 1
echo ""
echo "# wget"
wget --version | head -n 1
echo ""
printCommand openssl version
echo "# make"
make --version | head -n 1
echo ""
echo "# docker"
docker version 2>/dev/null | head -n+8
echo ""
printCommand terraform version