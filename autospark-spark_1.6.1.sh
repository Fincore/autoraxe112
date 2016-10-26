export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
cd /var/autospark/
mvn -Pyarn -Phadoop-2.4 -Dhadoop.version=2.4.0 -Dscala-2.11 -Phive -Phive-thriftserver -DskipTests clean package
