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
JAVA_VERSION=
JAVA_VERSION_BUILD=

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
    -v    Java version
    -b    Java build version
    -b    Java build UUID
    -h    Print this help message

  Example for 10:
  ${SCRIPTNAME} -v 10 -b 46 -u 76eac37278c24557a3c4199677f19b62

EOF

  if [ ! -z ${exit_code} ]; then
    exit ${exit_code}
  fi
}

while getopts "hv:b:u:p:" opt; do
  case ${opt} in
    v)
      JAVA_VERSION=${OPTARG}
      ;;
    b)
      JAVA_VERSION_BUILD=${OPTARG}
      ;;
    u)
      JAVA_VERSION_UUID=${OPTARG}
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

[ ! -z ${JAVA_VERSION} ] || print_usage 1 "Version not set"
[ ! -z ${JAVA_VERSION_BUILD} ] || print_usage 1 "Build version not set"
[ ! -z ${JAVA_VERSION_UUID} ] || print_usage 1 "Build UUID not set"


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
# jdk-9.0.1_linux-x64_bin.tar.gz
ORIGINAL_PACKAGE=${DOWNLOAD_DIR}/jdk-${JAVA_VERSION}_linux-x64_bin.tar.gz
JDK_DIRECTORY=${TEMP_DIR}/jdk-"${JAVA_VERSION}"
FINAL_ARTIFACT=${TARGET_DIR}/jdk-${JAVA_VERSION}.tar.gz


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
  download_from_oracle_com "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}+${JAVA_VERSION_BUILD}/${JAVA_VERSION_UUID}/jdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" "${DOWNLOAD_DIR}"
fi

tar -xzf ${ORIGINAL_PACKAGE} -C ${TEMP_DIR}

# set the egd to /dev/urandom
sed -i.bak 's;securerandom.source=.*;securerandom.source=file:/dev/urandom;g' ${JDK_DIRECTORY}/conf/security/java.security

tar -czf ${FINAL_ARTIFACT} -C ${TEMP_DIR} $(basename ${JDK_DIRECTORY})

# clean up
rm -rf ${TEMP_DIR}
