#!/bin/bash

# Locations
SCRIPTDIR=`cd $(dirname $0); pwd`
SCRIPTNAME=`basename $0`
WORKINGDIR=`pwd`

# configuration variables
JAVA_VERSION_MAJOR=8
JAVA_VERSION_UPDATE=121
JAVA_VERSION_BUILD=13
JAVA_VERSION_UUID=e9e7ea248e2c4826b92b3f075a80e441
# jdk or server-jre
JAVA_PACKAGE=server-jre
PROXY_SERVER=

print_usage() {
   cat << EOF
Usage: $SCRIPTNAME <options>
  <options>:
    -m    Java major version
    -u    Java update version
    -b    Java build version
    -g    Java version UUID (for Java 8u121 and greater)
    -j    Java package (jdk or server-jre)
    -h    Print this help message

  Example for server-jre 8u121:
  $SCRIPTNAME -m 8 -u 121 -b 13 -g e9e7ea248e2c4826b92b3f075a80e441

EOF
}

while getopts "hm:u:b:j:p:g:" opt; do
  case $opt in
    m)
      JAVA_VERSION_MAJOR=$OPTARG
      ;;
    u)
      JAVA_VERSION_UPDATE=$OPTARG
      ;;
    b)
      JAVA_VERSION_BUILD=$OPTARG
      ;;
    g)
      JAVA_VERSION_UUID="/$OPTARG"
      ;;
    j)
      JAVA_PACKAGE=$OPTARG
      ;;
    p)
      PROXY_SERVER=$OPTARG
      ;;
    h)
      print_usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


# convenience variables
TARGET_DIR=${WORKINGDIR}/target
DOWNLOAD_DIR=${TARGET_DIR}/download
TEMP_DIR=${TARGET_DIR}/tmp
ORIGINAL_PACKAGE=${DOWNLOAD_DIR}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz
JCE_PACKAGE=${DOWNLOAD_DIR}/jce_policy-${JAVA_VERSION_MAJOR}.zip
JCE_DIRECTORY=${TEMP_DIR}/UnlimitedJCEPolicyJDK${JAVA_VERSION_MAJOR}
JDK_DIRECTORY=${TEMP_DIR}/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_UPDATE}
FINAL_ARTIFACT=${TARGET_DIR}/${JAVA_PACKAGE}-1.${JAVA_VERSION_MAJOR}.0u${JAVA_VERSION_UPDATE}.tar.gz

# convenience functions
download_from_oracle_com() {
  url=$1
  download_dir=$2
  if [ -z $PROXY_SERVER ]; then
    (cd "${download_dir}" && curl -fLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" ${url})
  else
    (cd "${download_dir}" && curl -fLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -x $PROXY_SERVER ${url})
  fi
  if [ $? -ne 0 ]; then
    echo "Could not download artifact" 1>&2
    exit 1
  fi
}

# clean up first
if [ -f $TEMP_DIR ]; then
  rm -rf $TEMP_DIR
fi

# Create directories
mkdir -p "${TARGET_DIR}"
mkdir -p "${DOWNLOAD_DIR}"
mkdir -p "${TEMP_DIR}"

if [ ! -f $ORIGINAL_PACKAGE ]; then
  download_from_oracle_com "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-b${JAVA_VERSION_BUILD}${JAVA_VERSION_UUID}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz" "${DOWNLOAD_DIR}"
fi

if [ ! -f $JCE_PACKAGE ]; then
  download_from_oracle_com "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip" "${DOWNLOAD_DIR}"
fi
tar -xzf $ORIGINAL_PACKAGE -C ${TEMP_DIR}
unzip -q $JCE_PACKAGE -d ${TEMP_DIR}

# add the updated JCE policy files
mv ${JCE_DIRECTORY}/*.jar "${JDK_DIRECTORY}/jre/lib/security/"
# set the egd to /dev/urandom
sed -i.bak 's;securerandom.source=.*;securerandom.source=file:/dev/urandom;g' ${JDK_DIRECTORY}/jre/lib/security/java.security

if [ -f $FINAL_ARTIFACT ]; then
  rm $FINAL_ARTIFACT
fi
tar -czf ${FINAL_ARTIFACT} -C ${TEMP_DIR} $(basename ${JDK_DIRECTORY})

# clean up
rm -rf $TEMP_DIR

