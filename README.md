JDK Packager
============

A simple shell script that builds a JDK package.

Besides downloading the package the following actions will be performed:

 * install the unlimited strength JCE policy JAR
 * set the entropy gathering device to /dev/urandom


Options supported:

<dl>
<dt>-m</dt>
<dd>major java version eg. `8`</dd>
<dt>-u</dt>
<dd>update release -eg `45`</dd>
<dt>-b</dt>
<dd>build of the update release eg. `14`</dd>
<dt>-j</dt>
<dd>package to use `jdk` or `server-jre`</dd>
<dt>-p</dt>
<dd>proxy server to use</dd>
</dl>

The output will be in the `target/` folder

