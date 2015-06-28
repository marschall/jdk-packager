#!/bin/bash

# configuration variables
JAVA_VERSION_MAJOR=8
JAVA_VERSION_UPDATE=45
JAVA_VERSION_BUILD=14
JAVA_PACKAGE=server-jre
PROXY_SERVER=

while getopts "m:u:b:p:" opt; do
  case $opt in
    m)
      echo "major: $OPTARG" >&2
      JAVA_VERSION_MAJOR=OPTARG
      ;;
    u)
      echo "update: $OPTARG" >&2
      JAVA_VERSION_UPDATE=OPTARG
      ;;
    b)
      echo "build: $OPTARG" >&2
      JAVA_VERSION_UPDATE=OPTARG
      ;;
    p)
      echo "proxy: $OPTARG" >&2
      PROXY_SERVER=OPTARG
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

download_from_oracle_com() {
  if [ -z $PROXY_SERVER ]
    then
      echo "proxy host set" >&2
      curl -LOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" $1
    else
      echo "proxy host not set" >&2
      curl -LOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -x $PROXY_SERVER $1
  fi
}

if [ ! -f $ORIGINAL_PACKAGE ]
  then
    download_from_oracle_com "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_UPDATE}-linux-x64.tar.gz"
fi

if [ ! -f $JCE_PACKAGE ]
  then
    download_from_oracle_com "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip"
fi

tar xzf $ORIGINAL_PACKAGE
unzip -q $JCE_PACKAGE

# add the updated JCE policy files
mv ${JCE_DIRECTORY}/*.jar "${JDK_DIRECTORY}/jre/lib/security/"
# set the egd to /dev/urandom
sed -E "s/securerandom\.source=.*/securerandom\.source=file:\/dev\/urandom/g" ${JDK_DIRECTORY}/jre/lib/security/java.security > java.security~
mv java.security~ ${JDK_DIRECTORY}/jre/lib/security/java.security

tar -czf output-jdk-1.{JAVA_VERSION_MAJOR}.0u${JAVA_VERSION_BUILD}.tar.gz $JDK_DIRECTORY

# clean up
rm -rf $JCE_DIRECTORY
rm -rf $JDK_DIRECTORY

