# ML Kit text recognition references optional script recognizers (Chinese,
# Devanagari, Japanese, Korean) that we don't bundle (PaperDoc uses Latin).
# These rules let R8 ignore the missing optional classes so minification can be
# re-enabled for production release builds.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep ML Kit + Play Services vision classes that are accessed reflectively.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.vision.** { *; }
