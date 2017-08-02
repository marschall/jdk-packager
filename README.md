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
  <dd>update release -eg `144`</dd>
  <dt>-b</dt>
  <dd>build of the update release eg. `01`, you have to manually inspect the download links to find this out</dd>
  <dt>-g</dt>
  <dd>the UUID in the download URL (starting with 8u121) eg. `090f390dda5b47b9b721c7dfaa008135`, you have to manually inspect the download links to find this out, optional</dd>
  <dt>-j</dt>
  <dd>package to use `jdk` or `server-jre`</dd>
  <dt>-p</dt>
  <dd>proxy server to use</dd>
</dl>

For example to build the server JRE for Java 8 update 144 use the following

```sh
 ./jdk-packager.sh -m 8 -u 144 -b 01 -g 090f390dda5b47b9b721c7dfaa008135 -j server-jre
 ```
The output will be in the `target/` folder.

Or simply use

```sh
./package.sh server-jre-1.8.0_144
 ```

Currently only Linux x64 is supported.

