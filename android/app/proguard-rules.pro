# Regra para preservar classes do TensorFlow Lite
-keep class org.tensorflow.** { *; }
-keepclassmembers class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# Outras regras que você pode adicionar
-keep class com.google.** { *; }
-keepclassmembers class com.google.** { *; }
-dontwarn com.google.**
