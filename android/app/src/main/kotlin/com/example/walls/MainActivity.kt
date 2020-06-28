package com.example.walls

import android.app.WallpaperManager
import android.content.Context
import android.content.res.Resources
import android.graphics.BitmapFactory
import android.os.Build
import android.util.DisplayMetrics
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import kotlin.math.roundToInt


private const val CHANNEL = "com.example.walls/wallpaper"
class MainActivity: FlutterActivity() {

  @RequiresApi(Build.VERSION_CODES.N)
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    // GeneratedPluginRegistrant.registerWith(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "setWallpaper") {
        val arguments = call.arguments as ArrayList<*>
        val setWallpaper = setWallpaper(arguments[0] as String, applicationContext, arguments[1] as Int)

        if (setWallpaper == 0) {
          result.success(setWallpaper)
        } else {
          result.error("UNAVAILABLE", "", null)
        }
      } else if (call.method == "isDeviceNotched") {
        val ret = isDeviceNotched()
        result.success(ret)
      } else if (call.method == "getNavigationBarHeight") {
        val ret = getNavigationBarHeight()
        result.success(ret)
      } else if (call.method == "isGestureNavigation") {
        val ret = isGestureNavigation()
        result.success(ret)
      } else {
        result.notImplemented()
      }
    }
  }

  @RequiresApi(Build.VERSION_CODES.N)
  private fun setWallpaper(path: String, applicationContext: Context, wallpaperType: Int): Int {
    var setWallpaper = 1
    val bitmap = BitmapFactory.decodeFile(path)
    val wm: WallpaperManager? = WallpaperManager.getInstance(applicationContext)
    setWallpaper = try {
      wm?.setBitmap(bitmap, null, true, wallpaperType)
      0
    } catch (e: IOException) {
      1
    }

    return setWallpaper
  }

  private fun convertDpToPixel(dp: Float): Int {
    val metrics: DisplayMetrics = Resources.getSystem().displayMetrics
    val px = dp * (metrics.densityDpi / 160f)
    return px.roundToInt()
  }

  private fun isDeviceNotched(): Boolean {
    val cutoutMasked = resources.getBoolean(resources.getIdentifier("config_maskMainBuiltInDisplayCutout","bool","android"))
    if (cutoutMasked) return false

    val statusBarHeightResourceId = resources.getIdentifier("status_bar_height", "dimen", "android")
    var statusBarHeight = 0

    if (statusBarHeightResourceId > 0) {
      statusBarHeight = resources.getDimensionPixelSize(statusBarHeightResourceId);
    }
    if (statusBarHeight > convertDpToPixel(24.0F)) return true
    return false;
  }

  private fun getNavigationBarHeight(): Double {
    val resources = context.resources
    val resourceId = resources.getIdentifier("navigation_bar_height", "dimen", "android")
    if (resourceId > 0) {
      return resources.getDimensionPixelSize(resourceId).toDouble()
    }
    return 0.0
  }

  private fun isGestureNavigation(): Boolean {
    if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.P) {
      return false;
    }
    val cutoutMasked = resources.getInteger(resources.getIdentifier("config_navBarInteractionMode","integer","android"))
    if (cutoutMasked == 2) return true
    return false
  }
}
