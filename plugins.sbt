resolvers += "Typesafe repository" at "http://repo.typesafe.com/typesafe/releases/"

//resolvers += Resolver.sonatypeRepo
resolvers += Resolver.sonatypeRepo("snapshots")

// The Play plugin
addSbtPlugin("com.typesafe.play" % "sbt-plugin" % "2.3.1")

// web plugins

//addSbtPlugin("com.typesafe.sbt" % "sbt-coffeescript" % "1.0.0")

//addSbtPlugin("com.typesafe.sbt" % "sbt-less" % "1.0.0")

//not used

//addSbtPlugin("com.typesafe.sbt" % "sbt-jshint" % "1.0.1")

addSbtPlugin("com.typesafe.sbt" % "sbt-rjs" % "1.0.1")

addSbtPlugin("com.typesafe.sbt" % "sbt-digest" % "1.0.0")

addSbtPlugin("com.typesafe.sbt" % "sbt-mocha" % "1.0.0")

//addSbtPlugin("com.tuplejump" %% "sbt-yeoman" % "0.7.1-SNAPSHOT")
addSbtPlugin("com.tuplejump" % "sbt-yeoman" % "0.7.1")

//Add war support

//addSbtPlugin("com.github.play2war" % "play2-war-plugin" % "1.3-beta1")