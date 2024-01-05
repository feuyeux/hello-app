import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'system_util.dart';
import 'flip_panel.dart';

void main() {
  Stream.value(WidgetsFlutterBinding.ensureInitialized())
      .map((_) => debugPaintSizeEnabled = false)
      .map((_) =>
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            //状态栏
            systemNavigationBarColor: Color(0xfff0f0f0),
            //虚拟按键背景色
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            //虚拟按键图标色
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          )))
      .map((_) => SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeLeft]))
      .listen((_) => runApp(FlipClockApp()));
}

class FlipClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      title: 'FlipClock',
      home: FlipClockPage(),
    );
  }
}

class FlipClockPage extends StatefulWidget {
  const FlipClockPage({super.key});

  @override
  _FlipClockState createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClockPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    Wakelock.enable();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    final screenHeight = getScreenHeight(context);
    final width = screenWidth / 7;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Center(
        child: SizedBox(
          height: (width - 10) * 2 + 1,
          child: FlipClock(
            startTime: DateTime.now(),
            digitColor: Colors.white,
            backgroundColor: Colors.black,
            digitSize: screenWidth / 7,
            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
            width: width - 10,
            height: (width - 10) * 2,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        ),
      ),
    );
  }
}
