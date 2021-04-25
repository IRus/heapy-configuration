plugins {
    application
    kotlin("jvm").version("1.4.32")
}

application {
    applicationName = "updater"
    mainClass.set("io.heapy.updater.App")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.undertow:undertow-core:2.2.7.Final")
    implementation("ch.qos.logback:logback-classic:1.2.3")
}
