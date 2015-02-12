#!/bin/bash

# configuration variables
JAVA_VERSION_MAJOR=8
JAVA_VERSION_MINOR=31
JAVA_VERSION_BUILD=13
JAVA_PACKAGE=server-jre



ORIGINAL_PACKAGE=${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz
JCE_PACKAGE=jce_policy-${JAVA_VERSION_MAJOR}.zip
JCE_DIRECTORY=UnlimitedJCEPolicyJDK${JAVA_VERSION_MAJOR}
JDK_DIRECTORY=jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}

ORACLE_COOKIE=Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie

if [ ! -f $ORIGINAL_PACKAGE ]
  then
    curl -LOH $ORACLE_COOKIE "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz"
fi

if [ ! -f $JCE_PACKAGE ]
  then
    echo "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip"
    curl -LOH $ORACLE_COOKIE "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip"
fi

# tar xzf $ORIGINAL_PACKAGE
unzip -q $JCE_PACKAGE

exit 0
mv ${JCE_DIRECTORY}/*.jar "${JDK_DIRECTORY}/jre/lib/security/"
sed -E "s/securerandom\.source=.*/securerandom\.source=file:\/dev\/urandom/g" ${JDK_DIRECTORY}/jre/lib/security/java.security > java.security~
mv java.security~ ${JDK_DIRECTORY}/jre/lib/security/java.security

# clean up
rm -rf $JCE_DIRECTORY


