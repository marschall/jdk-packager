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
  <version>         Version to package, e.g. 1.8.0_162

  Example for jdk 1.8.0_162:
  ${SCRIPTNAME} jdk-1.8.0_162

EOF

  if [ ! -z ${exit_code} ]; then
    exit ${exit_code}
  fi
}

# main
case $1 in
     jdk-10) ${JDK_PACKAGER} -v 10 -b 46 -u 76eac37278c24557a3c4199677f19b62
     jdk-9.0.4) ${JDK_PACKAGER} -v 9 -b 11 -u c2514751926b4512b076cc82f959763f
     jdk-1.8.0_162) ${JDK_PACKAGER_8} -j jdk -m 8 -u 162 -b 12 -g 0da788060d494f5095bf8624735fa2f1;;
     jdk-1.8.0_161) ${JDK_PACKAGER_8} -j jdk -m 8 -u 161 -b 12 -g 2f38c3b165be4555a1fa6e98c45e0808;;
     server-jre-1.8.0_162) ${JDK_PACKAGER_8} -j server-jre -m 8 -u 162 -b 12 -g 0da788060d494f5095bf8624735fa2f1;;
     server-jre-1.8.0_161) ${JDK_PACKAGER_8} -j server-jre -m 8 -u 161 -b 12 -g 2f38c3b165be4555a1fa6e98c45e0808;;
     -h) print_usage 0;;
     *)  echo "Invalid option '$1'"
         print_usage 1
         ;;
esac
