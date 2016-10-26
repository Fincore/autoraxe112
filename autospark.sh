export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
cd /var/autospark/
mvn -Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.0 -Phive -Phive-thriftserver -DskipTests clean package
