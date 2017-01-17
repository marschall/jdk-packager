JDK Packager
============

A simple shell script that builds a JDK package.

Besides downloading the tarball the following actions will be performed:

 * install the unlimited strength JCE policy JAR
 * set the entropy gathering device to /dev/urandom

Options supported:

<dl>
  <dt>-m</dt>
  <dd>major java version eg. `8`</dd>
  <dt>-u</dt>
  <dd>update release -eg `121`</dd>
  <dt>-b</dt>
  <dd>build of the update release eg. `13`, you have to manually inspect the download links to find this out</dd>
  <dt>-g</dt>
  <dd>the UUID in the download URL (starting with 8u121) eg. `e9e7ea248e2c4826b92b3f075a80e441`, you have to manually inspect the download links to find this out, optional</dd>
  <dt>-j</dt>
  <dd>package to use `jdk` or `server-jre`</dd>
  <dt>-p</dt>
  <dd>proxy server to use</dd>
</dl>

For example to build the server JRE for Java 8 update 121 use the following

   /jdk-packager.sh -m 8 -u 121 -b 13 -g e9e7ea248e2c4826b92b3f075a80e441 -j server-jre

The output will be in the `target/` folder.

Currently only Linux x64 is supported.

