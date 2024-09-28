package com.example

import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.RequestHandler
import com.formkiq.lambda.runtime.graalvm.LambdaRuntime
import momosetkn.StubContext

class LambdaHandler : RequestHandler<String, String> {
    override fun handleRequest(event: String, context: Context): String {
        println("event: " + event)
        return "Hello from Kotlin Native!"
    }

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val handler = LambdaHandler()
            LambdaRuntime.innerMain(handler, args)
//            val env = getEnv()
//            println(env)
//
////            LambdaRuntime.invoke(env)
//            val handlerName = env["_HANDLER"];
//println(handlerName)
//            val handler = LambdaHandler()
//            val s = handler.handleRequest(
//                event = mapOf("key" to "value"),
//                context = StubContext()
//            )
//            println(s + "from main function")
        }

        private fun getEnv(): MutableMap<String, String> {
            val env: MutableMap<String, String> = HashMap(System.getenv())

            for ((key, value) in System.getProperties()) {
                env[key.toString()] = value.toString()
            }

            if (!env.containsKey("AWS_LAMBDA_RUNTIME_API")) {
                env["SINGLE_LOOP"] = "true"
            }
            return env
        }
    }
}
