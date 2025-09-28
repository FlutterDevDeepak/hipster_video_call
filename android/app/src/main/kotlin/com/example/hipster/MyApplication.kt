package com.example.hipster

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine

class MyApplication : Application() {
    private var flutterEngine: FlutterEngine? = null

    fun getFlutterEngine(): FlutterEngine {
        return flutterEngine ?: FlutterEngine(this).also { flutterEngine = it }
    }

    fun destroyFlutterEngine() {
        flutterEngine?.destroy()
        flutterEngine = null
    }
}