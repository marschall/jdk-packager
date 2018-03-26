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
  <dd>update release -eg `162`</dd>
  <dt>-b</dt>
  <dd>build of the update release eg. `12`, you have to manually inspect the download links to find this out</dd>
  <dt>-g</dt>
  <dd>the UUID in the download URL (starting with 8u121) eg. `0da788060d494f5095bf8624735fa2f1`, you have to manually inspect the download links to find this out, optional</dd>
  <dt>-j</dt>
  <dd>package to use `jdk` or `server-jre`</dd>
  <dt>-p</dt>
  <dd>proxy server to use</dd>
</dl>

For example to build the server JRE for Java 8 update 162 use the following

```sh
 ./jdk-packager-8.sh -m 8 -u 162 -b 12 -g 0da788060d494f5095bf8624735fa2f1 -j server-jre
 ```
The output will be in the `target/` folder.

Or simply use

```sh
./package.sh server-jre-1.8.0_162
 ```

Currently only Linux x64 is supported.

