package com.example

import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.RequestHandler

class LambdaHandler : RequestHandler<Map<String, String>, String> {
    override fun handleRequest(event: Map<String, String>, context: Context): String {
        return "Hello from Kotlin Native!"
    }
}
