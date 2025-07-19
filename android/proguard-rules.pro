# Flutter specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }

# Keep your MainActivity and Application
-keep class com.shishughar.creche.MainActivity { *; }
-keep class com.shishughar.creche.** { *; }




# Keep reflection used by plugins
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes Signature
-dontwarn io.flutter.embedding.**