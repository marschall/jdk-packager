#!/bin/bash

# Locations
SCRIPTDIR=`cd $(dirname $0); pwd`
SCRIPTNAME=`basename $0`
JDK_PACKAGER="${SCRIPTDIR}/jdk-packager.sh"

# Usage and option parsing
print_usage() {
exit_code=$1

  cat << EOF
Usage: ${SCRIPTNAME} (jdk|server-jre)-<version>
  jdk,server-jre    Whether to package a JDK or Server JRE
  <version>         Version to package, e.g. 1.8.0_152

  Example for jdk 1.8.0_152:
  ${SCRIPTNAME} jdk-1.8.0_152

EOF

  if [ ! -z ${exit_code} ]; then
    exit ${exit_code}
  fi
}

# main
case $1 in
     jdk-1.8.0_152) ${JDK_PACKAGER} -j jdk -m 8 -u 152 -b 16 -g aa0333dd3019491ca4f6ddbe78cdb6d0;;
     jdk-1.8.0_151) ${JDK_PACKAGER} -j jdk -m 8 -u 151 -b 12 -g e758a0de34e24606bca991d704f6dcbf;;
     server-jre-1.8.0_152) ${JDK_PACKAGER} -j server-jre -m 8 -u 152 -b 16 -g aa0333dd3019491ca4f6ddbe78cdb6d0;;
     server-jre-1.8.0_151) ${JDK_PACKAGER} -j server-jre -m 8 -u 151 -b 12 -g e758a0de34e24606bca991d704f6dcbf;;
     -h) print_usage 0;;
     *)  echo "Invalid option '$1'"
         print_usage 1
         ;;
esac
