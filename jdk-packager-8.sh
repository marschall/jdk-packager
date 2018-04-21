#!/bin/bash

set -e

# Locations
SCRIPTDIR=`cd $(dirname $0); pwd`
SCRIPTNAME=`basename $0`
WORKINGDIR=`pwd`
TARGET_DIR=./target
DOWNLOAD_DIR=${TARGET_DIR}/download
TEMP_DIR=${TARGET_DIR}/tmp

# configuration variables
JAVA_VERSION_MAJOR=
JAVA_VERSION_UPDATE=
JAVA_VERSION_BUILD=
JAVA_VERSION_UUID=
# jdk or server-jre
JAVA_PACKAGE=
PROXY_SERVER=

# Usage and option parsing
print_usage() {
  exit_code=$1
  additional_message="$2"

  if [ ! -z "${additional_message}" ]; then
    echo "${additional_message}"
  fi

  cat << EOF
Usage: ${SCRIPTNAME} <options>
  <options>:
    -m    Java major version
    -u    Java update version
    -b    Java build version
    -g    Java version UUID
    -j    Java package (jdk or server-jre)
    -h    Print this help message

  Example for server-jre 8u172:
  ${SCRIPTNAME} -m 8 -u 172 -b 11 -g a58eab1ec242421181065cdc37240b08

EOF

  if [ ! -z ${exit_code} ]; then
    exit ${exit_code}
  fi
}

while getopts "hm:u:b:j:p:g:" opt; do
  case ${opt} in
    m)
      JAVA_VERSION_MAJOR=${OPTARG}
      ;;
    u)
      JAVA_VERSION_UPDATE=${OPTARG}
      ;;
    b)
      JAVA_VERSION_BUILD=${OPTARG}
      ;;
    g)
      JAVA_VERSION_UUID="/${OPTARG}"
      ;;
    j)
      JAVA_PACKAGE=${OPTARG}
      ;;
    p)
      PROXY_SERVER=${OPTARG}
      ;;
    h)
      print_usage 0
      ;;
    \?)
      print_usage 1
      ;;
    :)
      print_usage 1 "Option requires an argument"
      ;;
  esac
done

[ ! -z ${JAVA_PACKAGE} ] || print_usage 1 "Java package not set"
[ ! -z ${JAVA_VERSION_MAJOR} ] || print_usage 1 "Major version not set"
[ ! -z ${JAVA_VERSION_UPDATE} ] || print_usage 1 "Update version not set"
[ ! -z ${JAVA_VERSION_BUILD} ] || print_usage 1 "Build version not set"

# Convenience functions
download_from_oracle_com() {
  url=$1
  echo "downloading ${url}"
  download_dir=$2
  if [ -z ${PROXY_SERVER} ]; then
    (cd "${download_dir}" && curl -fLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" ${url})
  else
    (cd "${download_dir}" && curl -fLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -x ${PROXY_SERVER} ${url})
  fi
  if [ $? -ne 0 ]; then
    echo "Could not download artifact" 1>&2
    exit 1
  fi
}

# Main
ORIGINAL_PACKAGE=${DOWNLOAD_DIR}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz
JDK_DIRECTORY=${TEMP_DIR}/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_UPDATE}
FINAL_ARTIFACT=${TARGET_DIR}/${JAVA_PACKAGE}-1.${JAVA_VERSION_MAJOR}.0u${JAVA_VERSION_UPDATE}.tar.gz


# prepare directories
if [ -f ${TEMP_DIR} ]; then
  rm -rf ${TEMP_DIR}
fi

if [ -f ${FINAL_ARTIFACT} ]; then
  rm ${FINAL_ARTIFACT}
fi

mkdir -p "${TARGET_DIR}"
mkdir -p "${DOWNLOAD_DIR}"
mkdir -p "${TEMP_DIR}"

if [ ! -f ${ORIGINAL_PACKAGE} ]; then
  download_from_oracle_com "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-b${JAVA_VERSION_BUILD}${JAVA_VERSION_UUID}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz" "${DOWNLOAD_DIR}"
fi

tar -xzf ${ORIGINAL_PACKAGE} -C ${TEMP_DIR}

# set crypto.policy to unlimited
sed -i.bak 's;^#crypto.policy=unlimited;crypto.policy=unlimited;g' ${JDK_DIRECTORY}/jre/lib/security/java.security

# set the egd to /dev/urandom
sed -i.bak 's;securerandom.source=.*;securerandom.source=file:/dev/urandom;g' ${JDK_DIRECTORY}/jre/lib/security/java.security

tar -czf ${FINAL_ARTIFACT} -C ${TEMP_DIR} $(basename ${JDK_DIRECTORY})

# clean up
rm -rf ${TEMP_DIR}
