#!/bin/bash

# Locations
BASEDIR=`cd $(dirname $0); pwd`
WORKINGDIR=`pwd`
SCRIPT_NAME=`basename $0`

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
Usage: $SCRIPT_NAME <options>
  <options>:
    -m    Java major version
    -u    Java update version
    -b    Java build version
    -g    Java version UUID (for Java 8u121 and greater)
    -j    Java package (jdk or server-jre)
    -h    Print this help message

  Example for server-jre 8u121:
  $SCRIPT_NAME -m 8 -u 121 -b 13 -g e9e7ea248e2c4826b92b3f075a80e441

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
ORIGINAL_PACKAGE=${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz
JCE_PACKAGE=jce_policy-${JAVA_VERSION_MAJOR}.zip
JCE_DIRECTORY=UnlimitedJCEPolicyJDK${JAVA_VERSION_MAJOR}
JDK_DIRECTORY=jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_UPDATE}
FINAL_ARTIFACT=target/${JAVA_PACKAGE}-1.${JAVA_VERSION_MAJOR}.0u${JAVA_VERSION_UPDATE}.tar.gz

# convenience functions
download_from_oracle_com() {
  if [ -z $PROXY_SERVER ]; then
    curl -fLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" $1
  else
    curl -fLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -x $PROXY_SERVER $1
  fi
  if [ $? -ne 0 ]; then
    echo "Could not download artifact" 1>&2
    exit 1
  fi
}

if [ ! -f $ORIGINAL_PACKAGE ]; then
  download_from_oracle_com "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-b${JAVA_VERSION_BUILD}${JAVA_VERSION_UUID}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz"
fi

if [ ! -f $JCE_PACKAGE ]; then
  download_from_oracle_com "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip"
fi
tar -xzf $ORIGINAL_PACKAGE
unzip -q $JCE_PACKAGE

# add the updated JCE policy files
mv ${JCE_DIRECTORY}/*.jar "${JDK_DIRECTORY}/jre/lib/security/"
# set the egd to /dev/urandom
sed -i.bak 's;securerandom.source=.*;securerandom.source=file:/dev/urandom;g' ${JDK_DIRECTORY}/jre/lib/security/java.security
mkdir -p target

if [ -f $FINAL_ARTIFACT ]; then
  rm $FINAL_ARTIFACT
fi
tar -czf $FINAL_ARTIFACT $JDK_DIRECTORY

# clean up
rm -rf $JCE_DIRECTORY
rm -rf $JDK_DIRECTORY

