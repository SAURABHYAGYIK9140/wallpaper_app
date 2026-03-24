#############################
# FLUTTER CORE
#############################
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.**  { *; }
-keep interface io.flutter.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}


# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

#############################
# ANDROIDX / LIFECYCLE
#############################
-keep class androidx.lifecycle.DefaultLifecycleObserver { *; }
-keep class androidx.lifecycle.FullLifecycleObserver { *; }
-keep class androidx.lifecycle.FullLifecycleObserverAdapter { *; }

-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes *Annotation*
-keepattributes MethodParameters

# Ignore Java compiler annotation classes
-dontwarn javax.lang.model.**
-dontwarn com.google.errorprone.annotations.**
-dontwarn org.checkerframework.**

#############################
# FIREBASE (ALL MODULES)
#############################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Fix for FCM background service removed by R8
-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }
-keep class com.google.firebase.messaging.** { *; }

# Crashlytics
-keep class com.google.firebase.crashlytics.** { *; }

#############################
# CRASHLYTICS DEBUG INFO
#############################
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

#############################
# PLAY CORE WARNINGS (Flutter references them)
#############################
-dontwarn com.google.android.play.core.**

#############################
# YOUR APP PACKAGE (IMPORTANT)
#############################
-keep class com.ito_technologies.soudan.** { *; }
-keep class com.saurabh.wallify.** { *; }

############ FLUTTERTOAST (IMPORTANT) ############
-keep class PonnamKarthik.** { *; }
-keep class io.github.ponnamkarthik.** { *; }
-keepclassmembers class * {
    *** showToast(...);
}

############ PATH_PROVIDER (IMPORTANT) ############
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.pathprovider_android.** { *; }
-keepclassmembers class io.flutter.plugins.pathprovider.** {
    public *** get*(...);
}

############ GAL PLUGIN ############
-keep class xyz.remeter.gal.** { *; }
-keepclassmembers class xyz.remeter.gal.** {
    public <methods>;
}

############ PERMISSION_HANDLER ############
-keep class com.baseflow.permissionhandler.** { *; }
-keepclassmembers class com.baseflow.permissionhandler.** {
    public <methods>;
}

############ WALLPAPER PLUGIN ############
-keep class it.alessandrorusso.** { *; }
-keepclassmembers class it.alessandrorusso.** {
    public <methods>;
}

############ DEVICE_INFO_PLUS ############
-keep class io.flutter.plugins.deviceinfoplus.** { *; }
-keepclassmembers class io.flutter.plugins.deviceinfoplus.** {
    public <methods>;
}

############ SHARED_PREFERENCES ############
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class androidx.preference.** { *; }
-keepclassmembers class io.flutter.plugins.sharedpreferences.** {
    public <methods>;
}
-keep class * extends io.flutter.plugins.sharedpreferences.SharedPreferencesApi { *; }

# Keep all Pigeon-generated API implementation classes
-keep interface * {
    *** onSuccess(...);
    *** onError(...);
}

############ CONNECTIVITY_PLUS ############
-keep class io.flutter.plugins.connectivity.** { *; }
-keepclassmembers class io.flutter.plugins.connectivity.** {
    public <methods>;
}

############ URL_LAUNCHER ############
-keep class io.flutter.plugins.urllauncher.** { *; }
-keepclassmembers class io.flutter.plugins.urllauncher.** {
    public <methods>;
}

############ JUST AUDIO (IMPORTANT) ############
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audio_session.** { *; }
-dontwarn com.ryanheise.just_audio.**
-dontwarn com.ryanheise.audio_session.**

# ExoPlayer (used internally by just_audio)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
