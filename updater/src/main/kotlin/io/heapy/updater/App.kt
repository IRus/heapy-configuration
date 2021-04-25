@file:JvmName("App")
package io.heapy.updater

import io.undertow.Undertow
import io.undertow.server.RoutingHandler
import kotlin.concurrent.thread

fun main() {
    val rootHandler = RoutingHandler()
        .get("versions", { it.responseSender.send("Version") })
        .post("update", { it.responseSender.send("Update") })

    val undertow = Undertow.builder()
        .addHttpListener(8080, "0.0.0.0", rootHandler)
        .build()

    undertow.start()

    Runtime.getRuntime().addShutdownHook(thread(start = false) {
        undertow.stop()
    })
}
