# Flutter Proguard Rules
# Keep Flutter's animations functionality
-keep class io.flutter.animation.** { *; }

# Keep Flutter's plugin registry
-keep class io.flutter.plugin.** { *; }

# Keep specific Flutter classes
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Kotlin metadata
-keepattributes *Annotation*, InnerClasses, Signature, Exceptions, SourceFile, LineNumberTable, EnclosingMethod

# Specifically for your app
-keepclassmembers class raffle.com.raffle.** { *; }

# Basic Android classes
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Required for Firebase if you're using it
-keepattributes EnclosingMethod
-keepattributes InnerClasses 