export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M"
./build/mvn -Pyarn -Phadoop-2.4 -Dhadoop.version=2.4.0 -DskipTests clean package