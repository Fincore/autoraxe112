//import com.github.play2war.plugin._

import com.tuplejump.sbt.yeoman.Yeoman

name := """queryhub"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.1"

//Play2WarPlugin.play2WarSettings

//Play2WarKeys.servletVersion := "2.5"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache,
  ws,
"com.tuplejump" % "play-yeoman_2.11" % "0.7.1",
"org.scalaj" %% "scalaj-http" % "0.3.16",
"org.json4s" % "json4s-core_2.11" % "3.2.11",
"org.apache.spark" % "spark-catalyst_2.11" % "1.4.1",
"org.apache.spark" % "spark-core_2.11" % "1.4.1",
"org.apache.spark" % "spark-sql_2.11" % "1.4.1",
"org.apache.spark" % "spark-hive_2.11" % "1.4.1",
"org.apache.spark" % "spark-streaming_2.11" % "1.4.1",
//"org.apache.spark" % "spark-launcher_2.11" % "1.4.1",
"org.apache.spark" % "spark-network-common_2.11" % "1.4.1",
"org.apache.spark" % "spark-network-shuffle_2.11" % "1.4.1",
"org.apache.spark" % "spark-parent_2.11" % "1.4.1",
//"org.apache.spark" % "spark-unsafe_2.11" % "1.4.1",
"org.spark-project.hive" % "hive" % "0.13.1a",
"org.spark-project.hive" % "hive-ant" % "0.13.1a",
"org.spark-project.hive" % "hive-common" % "0.13.1a",
"org.spark-project.hive" % "hive-exec" % "0.13.1a",
"org.spark-project.hive" % "hive-metastore" % "0.13.1a",
"org.spark-project.hive" % "hive-serde" % "0.13.1a",
"org.spark-project.hive" % "hive-shims" % "0.13.1a",
//"org.apache.hive" % "hive-exec" % "0.13.1",
"com.typesafe.akka" % "akka-actor_2.11" % "2.3.4",
"com.typesafe.akka" % "akka-remote_2.11" % "2.3.4"
)


   Yeoman.yeomanSettings ++
    Yeoman.withTemplates