# flip clock

<https://github.com/Crazy-MT/flutter_flip_clock>

```sh
flutter doctor
```

on windows

```sh
flutter create . --platforms windows
flutter clean
flutter run -d windows
```

on android

```sh
flutter create . --platforms android
flutter run
```

flutter run ISSUES

> **Launching lib\main.dart on sdk gphone64 x86 64 in debug mode...**
> **Exception in thread "main" java.net.ConnectException: Connection timed out: connect**
>
> `android\app\build.gradle`:
>
> ```groovy
> println "flutter.compileSdkVersion: $flutter.compileSdkVersion"
> println "android.buildToolsVersion: $android.buildToolsVersion"
> println "flutter.targetSdkVersion: $flutter.targetSdkVersion"
> println "flutter.minSdkVersion: $flutter.minSdkVersion"
> println "flutter.ndkVersion: $flutter.ndkVersion"
> 
> android {
> 
>     compileSdkVersion flutter.compileSdkVersion
>     ndkVersion flutter.ndkVersion
> ...
> ```  
>
> **Running Gradle task ”assembleDebug“ ...**
>
> `android\build.gradle`:
>
> ```groovy
> repositories {
>  google()
>  mavenCentral()
> 
>  maven { url 'https://maven.aliyun.com/repository/google' }
>  maven { url 'https://maven.aliyun.com/repository/jcenter' }
>  maven { url 'http://maven.aliyun.com/nexus/content/groups/public' }
> 
> }
> ```
