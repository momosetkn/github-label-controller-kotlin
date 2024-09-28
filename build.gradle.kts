plugins {
    kotlin("jvm") version "2.0.20"
    id("com.github.johnrengelman.shadow") version "8.1.1"
    java
//    id("org.graalvm.buildtools.native") version "0.10.3"
}

group = "momosetkn"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("com.amazonaws:aws-lambda-java-core:1.2.1")
    implementation("com.amazonaws:aws-lambda-java-events:3.12.0")
//    implementation("com.formkiq:lambda-runtime-graalvm:2.4.0")

    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(17)
}

tasks {
    withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
        mergeServiceFiles()
        // entry-point
        manifest {
            attributes(
                "Main-Class" to "com.example.LambdaHandler"
//                "Main-Class" to "com.formkiq.lambda.runtime.graalvm.LambdaRuntime"
            )
        }
    }
}
//
//graalvmNative {
//    binaries.all {
//        resources.autodetect()
//    }
//}