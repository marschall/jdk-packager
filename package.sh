#!/bin/bash

# Locations
SCRIPTDIR=`cd $(dirname $0); pwd`
SCRIPTNAME=`basename $0`
JDK_PACKAGER="${SCRIPTDIR}/jdk-packager.sh"
JDK_PACKAGER_8="${SCRIPTDIR}/jdk-packager-8.sh"

# Usage and option parsing
print_usage() {
exit_code=$1

  cat << EOF
Usage: ${SCRIPTNAME} (jdk|server-jre)-<version>
  jdk,server-jre    Whether to package a JDK or Server JRE
  <version>         Version to package, e.g. 1.8.0_172

  Example for jdk 1.8.0_172:
  ${SCRIPTNAME} jdk-1.8.0_172

EOF

  if [ ! -z ${exit_code} ]; then
    exit ${exit_code}
  fi
}

# main
case $1 in
     jdk-10.0.1) ${JDK_PACKAGER} -v 10.0.1 -b 10 -u fb4372174a714e6b8c52526dc134031e;;
     jdk-1.8.0_172) ${JDK_PACKAGER_8} -j jdk -m 8 -u 172 -b 11 -g a58eab1ec242421181065cdc37240b08;;
     jdk-1.8.0_171) ${JDK_PACKAGER_8} -j jdk -m 8 -u 171 -b 11 -g 512cd62ec5174c3487ac17c61aaa89e8;;
     server-jre-1.8.0_172) ${JDK_PACKAGER_8} -j server-jre -m 8 -u 172 -b 11 -g a58eab1ec242421181065cdc37240b08;;
     server-jre-1.8.0_161) ${JDK_PACKAGER_8} -j server-jre -m 8 -u 171 -b 11 -g 512cd62ec5174c3487ac17c61aaa89e8;;
     -h) print_usage 0;;
     *)  echo "Invalid option '$1'"
         print_usage 1
         ;;
esac
