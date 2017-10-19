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
  <version>         Version to package, e.g. 1.8.0_144

  Example for jdk 1.8.0_144:
  ${SCRIPTNAME} jdk-1.8.0_144

EOF

  if [ ! -z ${exit_code} ]; then
    exit ${exit_code}
  fi
}

# main
case $1 in
     jdk-1.8.0_152) ${JDK_PACKAGER} -j jdk -m 8 -u 152 -b 16 -g aa0333dd3019491ca4f6ddbe78cdb6d0;;
     jdk-1.8.0_141) ${JDK_PACKAGER} -j jdk -m 8 -u 141 -b 15 -g 336fa29ff2bb4ef291e347e091f7f4a7;;
     jdk-1.8.0_131) ${JDK_PACKAGER} -j jdk -m 8 -u 131 -b 11 -g d54c1d3a095b4ff2b6607d096fa80163;;
     jdk-1.8.0_121) ${JDK_PACKAGER} -j jdk -m 8 -u 121 -b 13 -g e9e7ea248e2c4826b92b3f075a80e441;;
     jdk-1.8.0_112) ${JDK_PACKAGER} -j jdk -m 8 -u 102 -b 15;;
     jdk-1.8.0_111) ${JDK_PACKAGER} -j jdk -m 8 -u 102 -b 14;;
     jdk-1.8.0_102) ${JDK_PACKAGER} -j jdk -m 8 -u 102 -b 14;;
     jdk-1.8.0_101) ${JDK_PACKAGER} -j jdk -m 8 -u 101 -b 13;;
     jdk-1.8.0_92)  ${JDK_PACKAGER} -j jdk -m 8 -u 92 -b 14;;
     jdk-1.8.0_91)  ${JDK_PACKAGER} -j jdk -m 8 -u 91 -b 14;;
     jdk-1.8.0_77)  ${JDK_PACKAGER} -j jdk -m 8 -u 77 -b 03;;
     jdk-1.8.0_74)  ${JDK_PACKAGER} -j jdk -m 8 -u 74 -b 02;;
     jdk-1.8.0_73)  ${JDK_PACKAGER} -j jdk -m 8 -u 73 -b 02;;
     jdk-1.8.0_72)  ${JDK_PACKAGER} -j jdk -m 8 -u 72 -b 15;;
     jdk-1.8.0_71)  ${JDK_PACKAGER} -j jdk -m 8 -u 71 -b 15;;
     jdk-1.8.0_66)  ${JDK_PACKAGER} -j jdk -m 8 -u 66 -b 17;;
     jdk-1.8.0_65)  ${JDK_PACKAGER} -j jdk -m 8 -u 65 -b 17;;
     jdk-1.8.0_60)  ${JDK_PACKAGER} -j jdk -m 8 -u 60 -b 27;;
     jdk-1.8.0_51)  ${JDK_PACKAGER} -j jdk -m 8 -u 51 -b 16;;
     jdk-1.8.0_45)  ${JDK_PACKAGER} -j jdk -m 8 -u 45 -b 14;;
     jdk-1.8.0_40)  ${JDK_PACKAGER} -j jdk -m 8 -u 40 -b 26;;
     jdk-1.8.0_31)  ${JDK_PACKAGER} -j jdk -m 8 -u 31 -b 13;;
     jdk-1.8.0_25)  ${JDK_PACKAGER} -j jdk -m 8 -u 25 -b 17;;
     jdk-1.8.0_20)  ${JDK_PACKAGER} -j jdk -m 8 -u 20 -b 26;;
     jdk-1.8.0_11)  ${JDK_PACKAGER} -j jdk -m 8 -u 11 -b 12;;
     jdk-1.8.0_05)  ${JDK_PACKAGER} -m 8 -u 5  -b 13;;
     server-jre-1.8.0_152) ${JDK_PACKAGER} -j server-jre -m 8 -u 152 -b 16 -g aa0333dd3019491ca4f6ddbe78cdb6d0;;
     server-jre-1.8.0_131) ${JDK_PACKAGER} -j server-jre -m 8 -u 131 -b 11 -g d54c1d3a095b4ff2b6607d096fa80163;;
     server-jre-1.8.0_121) ${JDK_PACKAGER} -j server-jre -m 8 -u 121 -b 13 -g e9e7ea248e2c4826b92b3f075a80e441;;
     server-jre-1.8.0_112) ${JDK_PACKAGER} -j server-jre -m 8 -u 102 -b 15;;
     server-jre-1.8.0_111) ${JDK_PACKAGER} -j server-jre -m 8 -u 102 -b 14;;
     server-jre-1.8.0_102) ${JDK_PACKAGER} -j server-jre -m 8 -u 102 -b 14;;
     server-jre-1.8.0_101) ${JDK_PACKAGER} -j server-jre -m 8 -u 101 -b 13;;
     server-jre-1.8.0_92)  ${JDK_PACKAGER} -j server-jre -m 8 -u 92 -b 14;;
     server-jre-1.8.0_91)  ${JDK_PACKAGER} -j server-jre -m 8 -u 91 -b 14;;
     server-jre-1.8.0_77)  ${JDK_PACKAGER} -j server-jre -m 8 -u 77 -b 03;;
     server-jre-1.8.0_74)  ${JDK_PACKAGER} -j server-jre -m 8 -u 74 -b 02;;
     server-jre-1.8.0_73)  ${JDK_PACKAGER} -j server-jre -m 8 -u 73 -b 02;;
     server-jre-1.8.0_72)  ${JDK_PACKAGER} -j server-jre -m 8 -u 72 -b 15;;
     server-jre-1.8.0_71)  ${JDK_PACKAGER} -j server-jre -m 8 -u 71 -b 15;;
     server-jre-1.8.0_66)  ${JDK_PACKAGER} -j server-jre -m 8 -u 66 -b 17;;
     server-jre-1.8.0_65)  ${JDK_PACKAGER} -j server-jre -m 8 -u 65 -b 17;;
     server-jre-1.8.0_60)  ${JDK_PACKAGER} -j server-jre -m 8 -u 60 -b 27;;
     server-jre-1.8.0_51)  ${JDK_PACKAGER} -j server-jre -m 8 -u 51 -b 16;;
     server-jre-1.8.0_45)  ${JDK_PACKAGER} -j server-jre -m 8 -u 45 -b 14;;
     server-jre-1.8.0_40)  ${JDK_PACKAGER} -j server-jre -m 8 -u 40 -b 26;;
     server-jre-1.8.0_31)  ${JDK_PACKAGER} -j server-jre -m 8 -u 31 -b 13;;
     server-jre-1.8.0_25)  ${JDK_PACKAGER} -j server-jre -m 8 -u 25 -b 17;;
     server-jre-1.8.0_20)  ${JDK_PACKAGER} -j server-jre -m 8 -u 20 -b 26;;
     server-jre-1.8.0_11)  ${JDK_PACKAGER} -j server-jre -m 8 -u 11 -b 12;;
     server-jre-1.8.0_05)  ${JDK_PACKAGER} -j server-jre -m 8 -u 5  -b 13;;
     -h) print_usage 0;;
     *)  echo "Invalid option '$1'"
         print_usage 1
         ;;
esac
