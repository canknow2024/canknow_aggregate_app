# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep WebView related classes
-keep class android.webkit.** { *; }

# Keep JVerify related classes
-keep class com.jiguang.** { *; }
-keep class cn.jpush.** { *; }

# Keep WeChat related classes
-keep class com.tencent.mm.** { *; }
-keep class com.tencent.wxop.** { *; }

# Keep device info related classes
-keep class com.hihonor.ads.identifier.** { *; }
-keep class com.cmic.gen.sdk.** { *; }

# Keep Google Play Core classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Honor/Huawei advertising identifier classes
-dontwarn com.hihonor.ads.identifier.**

# Keep Flutter plugins
-keep class io.flutter.plugins.webviewflutter.** { *; }
-keep class io.flutter.plugins.deviceinfo.** { *; }
-keep class io.flutter.plugins.fluttertoast.** { *; }
-keep class io.flutter.plugins.fluwx.** { *; }

# Keep JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Retrofit/Dio related classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Keep OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**

# Keep Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep SharedPreferences
-keep class android.content.SharedPreferences { *; }

# Keep FileProvider
-keep class androidx.core.content.FileProvider { *; }
-keep class androidx.core.content.FileProvider$SimplePathStrategy { *; }

# Keep ImagePicker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep PathProvider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep PhotoView
-keep class com.github.chrisbanes.photoview.** { *; }

# Keep Vibration
-keep class io.flutter.plugins.vibration.** { *; }

# Keep FlutterPicker
-keep class com.bigkoo.pickerview.** { *; }

# Keep SignInWithApple
-keep class com.aboutyou.dart_packages.sign_in_with_apple.** { *; }

# Keep PackageInfoPlus
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }

# Keep Shimmer
-keep class io.github.shreyashsaitwal.rush.** { *; }

# Keep CachedNetworkImage
-keep class com.github.bumptech.glide.** { *; }

# Keep FlutterWidgetFromHtml
-keep class io.github.zeshuaro.google_api_headers.** { *; }

# Keep FlutterDownloader
-keep class vn.hunghd.flutterdownloader.** { *; }

# Keep Synchronized
-keep class com.github.davidmoten.rx2.** { *; }

# Keep Provider
-keep class io.flutter.plugins.provider.** { *; }

# Keep Riverpod
-keep class * extends androidx.lifecycle.ViewModel { *; }

# Keep GoRouter
-keep class io.flutter.plugins.go_router.** { *; }

# Keep EasyLocalization
-keep class com.aissat.easy_localization.** { *; }

# Keep Crypto
-keep class * extends java.security.MessageDigest { *; }

# Keep PrettyDioLogger
-keep class com.github.mrmike.** { *; }

# Keep JSON Annotation
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep all classes in your app package
-keep class com.canknow.canknow_aggregate_app.** { *; }

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes that might be used in XML layouts
-keep public class * extends android.view.View
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.preference.Preference
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.PreferenceActivity

# Keep all classes that might be used in AndroidManifest.xml
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgent
-keep public class * extends android.preference.Preference
-keep public class * extends android.app.Fragment

# Keep all classes that might be used in layout XML files
-keep public class * extends android.view.View
-keep public class * extends android.view.ViewGroup
-keep public class * extends android.widget.BaseAdapter
-keep public class * extends android.widget.AdapterView
-keep public class * extends android.widget.CompoundButton
-keep public class * extends android.widget.LinearLayout
-keep public class * extends android.widget.RelativeLayout
-keep public class * extends android.widget.FrameLayout
-keep public class * extends android.widget.AbsoluteLayout
-keep public class * extends android.widget.TableLayout
-keep public class * extends android.widget.TableRow
-keep public class * extends android.widget.GridLayout
-keep public class * extends android.widget.ScrollView
-keep public class * extends android.widget.HorizontalScrollView
-keep public class * extends android.widget.ListView
-keep public class * extends android.widget.GridView
-keep public class * extends android.widget.Spinner
-keep public class * extends android.widget.TabHost
-keep public class * extends android.widget.TabWidget
-keep public class * extends android.widget.TextView
-keep public class * extends android.widget.Button
-keep public class * extends android.widget.ImageView
-keep public class * extends android.widget.ImageButton
-keep public class * extends android.widget.CheckBox
-keep public class * extends android.widget.RadioButton
-keep public class * extends android.widget.RadioGroup
-keep public class * extends android.widget.EditText
-keep public class * extends android.widget.AutoCompleteTextView
-keep public class * extends android.widget.MultiAutoCompleteTextView
-keep public class * extends android.widget.SeekBar
-keep public class * extends android.widget.ProgressBar
-keep public class * extends android.widget.RatingBar
-keep public class * extends android.widget.Switch
-keep public class * extends android.widget.ToggleButton
-keep public class * extends android.widget.CheckedTextView
-keep public class * extends android.widget.ExpandableListView
-keep public class * extends android.widget.SlidingDrawer
-keep public class * extends android.widget.WebView
-keep public class * extends android.widget.VideoView
-keep public class * extends android.widget.SurfaceView
-keep public class * extends android.widget.TextureView
-keep public class * extends android.widget.GLSurfaceView
-keep public class * extends android.widget.AbsListView
-keep public class * extends android.widget.AbsSpinner
-keep public class * extends android.widget.AdapterViewAnimator
-keep public class * extends android.widget.StackView
-keep public class * extends android.widget.ViewAnimator
-keep public class * extends android.widget.ViewFlipper
-keep public class * extends android.widget.ViewSwitcher
-keep public class * extends android.widget.ImageSwitcher
-keep public class * extends android.widget.TextSwitcher
-keep public class * extends android.widget.Gallery
-keep public class * extends android.widget.HorizontalScrollView
-keep public class * extends android.widget.ScrollView
-keep public class * extends android.widget.ViewStub
-keep public class * extends android.widget.ZoomControls
-keep public class * extends android.widget.ZoomButton
-keep public class * extends android.widget.AnalogClock
-keep public class * extends android.widget.DigitalClock
-keep public class * extends android.widget.Chronometer
-keep public class * extends android.widget.TextClock
-keep public class * extends android.widget.CalendarView
-keep public class * extends android.widget.DatePicker
-keep public class * extends android.widget.TimePicker
-keep public class * extends android.widget.NumberPicker
-keep public class * extends android.widget.Space
-keep public class * extends android.widget.Switch
-keep public class * extends android.widget.ToggleButton
-keep public class * extends android.widget.CheckedTextView
-keep public class * extends android.widget.ExpandableListView
-keep public class * extends android.widget.SlidingDrawer
-keep public class * extends android.widget.WebView
-keep public class * extends android.widget.VideoView
-keep public class * extends android.widget.SurfaceView
-keep public class * extends android.widget.TextureView
-keep public class * extends android.widget.GLSurfaceView
-keep public class * extends android.widget.AbsListView
-keep public class * extends android.widget.AbsSpinner
-keep public class * extends android.widget.AdapterViewAnimator
-keep public class * extends android.widget.StackView
-keep public class * extends android.widget.ViewAnimator
-keep public class * extends android.widget.ViewFlipper
-keep public class * extends android.widget.ViewSwitcher
-keep public class * extends android.widget.ImageSwitcher
-keep public class * extends android.widget.TextSwitcher
-keep public class * extends android.widget.Gallery
-keep public class * extends android.widget.HorizontalScrollView
-keep public class * extends android.widget.ScrollView
-keep public class * extends android.widget.ViewStub
-keep public class * extends android.widget.ZoomControls
-keep public class * extends android.widget.ZoomButton
-keep public class * extends android.widget.AnalogClock
-keep public class * extends android.widget.DigitalClock
-keep public class * extends android.widget.Chronometer
-keep public class * extends android.widget.TextClock
-keep public class * extends android.widget.CalendarView
-keep public class * extends android.widget.DatePicker
-keep public class * extends android.widget.TimePicker
-keep public class * extends android.widget.NumberPicker
-keep public class * extends android.widget.Space 