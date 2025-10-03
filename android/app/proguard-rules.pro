# Keep permission_handler classes
-keep class com.baseflow.** { *; }
-keep class androidx.lifecycle.** { *; }
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Optional: keep Flutter embedding
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

