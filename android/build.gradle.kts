allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// mediapipe_face_mesh hardcodes a broken NDK on some machines — force a working one.
subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android") ?: return@afterEvaluate
        try {
            val setter = androidExt.javaClass.methods.firstOrNull {
                it.name == "setNdkVersion" && it.parameterTypes.size == 1
            }
            setter?.invoke(androidExt, "27.0.12077973")
        } catch (_: Exception) {
            // Plugin may not expose ndkVersion; ignore.
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
