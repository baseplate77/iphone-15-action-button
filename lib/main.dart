import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:ios_action_button_animation/model/action_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              textTheme: GoogleFonts.interTextTheme().copyWith(),
              // useMaterial3: true,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  ImageSequenceAnimatorState? get imageSequenceAnimator =>
      isOnline ? onlineImageSequenceAnimator : offlineImageSequenceAnimator;
  ImageSequenceAnimatorState? offlineImageSequenceAnimator;
  ImageSequenceAnimatorState? onlineImageSequenceAnimator;
  late PageController _pageController;
  late AnimationController _controller;
  late Animation<double> _animation;
  final _pageNotifier = ValueNotifier(0.0);
  int currentindex = 0;
  bool isOnline = false;
  bool wasPlaying = false;
  Timer? t;

  Color color1 = Colors.greenAccent;
  Color color2 = Colors.indigo;

  // String onlineOfflineText = "Use Online";
  // String loopText = "Start Loop";
  // String boomerangText = "Start Boomerang";

  void _listener() {
    _pageNotifier.value = _pageController.page!;
  }

  void onOfflineReadyToPlay(ImageSequenceAnimatorState _imageSequenceAnimator) {
    offlineImageSequenceAnimator = _imageSequenceAnimator;
    _controller.forward();
    _imageSequenceAnimator.play();
  }

  void onOfflinePlaying(ImageSequenceAnimatorState _imageSequenceAnimator) {
    setState(() {});
  }

  void onOnlineReadyToPlay(ImageSequenceAnimatorState _imageSequenceAnimator) {
    onlineImageSequenceAnimator = _imageSequenceAnimator;
  }

  void onOnlinePlaying(ImageSequenceAnimatorState _imageSequenceAnimator) {
    setState(() {});
  }

  List<ActionDetails> actionButtons = [
    ActionDetails(
        iconsPath: "assets/icons/slient.png",
        title: "Silent Mode",
        desc: "Switch between Silent and Ring for calls\nand alerts."),
    ActionDetails(
        iconsPath: "assets/icons/focus.png",
        title: "Focus",
        desc:
            "Turn Focus on the silence notification and\nfilter out distractions."),
    ActionDetails(
        iconsPath: "assets/icons/camera.png",
        title: "Camera",
        desc: "Open the Camera app to capture\na moment."),
    ActionDetails(
        iconsPath: "assets/icons/touch.png",
        title: "Touch",
        desc: "Turn on extra light when you need it."),
    ActionDetails(
        iconsPath: "assets/icons/voice.png",
        title: "Voice",
        desc: "Recoard peronal notes, musical ideas\nand more."),
    ActionDetails(
        iconsPath: "assets/icons/magnify.png",
        title: "Magnify",
        desc:
            "Turn your iPhone into a magnifyinh gal to\nzoom in on and detect objects near you."),
    ActionDetails(
        iconsPath: "assets/icons/shotcut.png",
        title: "Shotcut",
        desc: "Open an app or run your favorite shortcut"),
    ActionDetails(
        iconsPath: "assets/icons/accessibility.png",
        title: "Accessibility",
        desc: "Quickly use an ccessibility feature."),
  ];
  List<Color> actionColor = const [
    Color.fromRGBO(255, 147, 39, 1),
    Color.fromARGB(255, 31, 91, 255),
    Color.fromARGB(15, 255, 216, 60),
    Color.fromARGB(15, 90, 142, 255),
    Color(0xffD73735),
    Color(0xff7A9AC3),
    Colors.transparent,
    Colors.transparent,
  ];
  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.35);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.addListener(_listener);
    });

    for (int i = 0; i <= 30; i++) {
      String path = "assets/animation/frame_00";
      if (i / 10 < 1) {
        path += "0$i.png";
      } else {
        path += "$i.png";
      }
      scheduleMicrotask(() async {
        await precacheImage(AssetImage(path), context);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          SizedBox(
            height: 1.sh,
            width: 1.sw,
          ),
          Align(
            alignment: Alignment.center,
            child: ImageSequenceAnimator(
              "assets/animation",
              "frame_",
              0,
              4,
              "png",
              30,
              key: const Key("action button"),
              isAutoPlay: false,
              fps: 30,
              onReadyToPlay: onOfflineReadyToPlay,
              onPlaying: onOfflinePlaying,
            ),
          ),
          Container(
            height: 1.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black,
                  Colors.black87,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black87,
                  Colors.black,
                  Colors.black
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.05, 0.12, 0.15, 0.3, 0.55, 0.8, 0.9, 0.95],
              ),
            ),
          ),
          Positioned(
              bottom: 0.18.sh,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                        actionButtons.length,
                        (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: currentindex == index
                                    ? Colors.white
                                    : Colors.grey.shade300,
                              ),
                            )),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    actionButtons[currentindex].title,
                    style: TextStyle(fontSize: 28.sp, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(actionButtons[currentindex].desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white54,
                      ))
                ],
              )),
          Positioned.fill(
            top: -140.h,
            bottom: 0,
            left: -70.w,
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  _pageController = PageController(
                    viewportFraction: _animation.value == 0
                        ? 0.3
                        : _animation.value == 1
                            ? 0.2
                            : lerpDouble(0.3, 0.2, _animation.value)!,
                  );
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.01 * _animation.value * 5)
                      ..rotateY(-0.01 * _animation.value * -25),
                    child: Transform.translate(
                      offset:
                          Offset(lerpDouble(40.w, -5.w, _animation.value)!, 0),
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          itemCount: actionButtons.length,
                          onPageChanged: (value) {
                            currentindex = value;
                            _controller.reverse();
                            imageSequenceAnimator?.rewind();

                            if (t != null) {
                              t!.cancel();
                            }

                            t = Timer(const Duration(seconds: 2), () {
                              _controller.forward();
                              imageSequenceAnimator?.restart();
                            });

                            setState(() {});
                          },
                          itemBuilder: (context, index) => Transform.scale(
                                scale: _animation.value == 0
                                    ? 0.7
                                    : _animation.value == 1
                                        ? 0.5
                                        : lerpDouble(
                                            0.7, 0.5, _animation.value),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 1.sw,
                                      height: 1.sh,
                                    ),
                                    Container(
                                      width: lerpDouble(
                                          130.h, 120.h, _animation.value),
                                      height: lerpDouble(
                                          280.h, 260.h, _animation.value),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: currentindex == index &&
                                                actionColor[currentindex] !=
                                                    Colors.transparent
                                            ? actionColor[currentindex]
                                                .withOpacity(0.3)
                                            : Colors.transparent,
                                        backgroundBlendMode: BlendMode.color,
                                        boxShadow: currentindex == index &&
                                                actionColor[currentindex] !=
                                                    Colors.transparent
                                            ? [
                                                BoxShadow(
                                                  color:
                                                      actionColor[currentindex]
                                                          .withOpacity(0.6),
                                                  blurRadius: 30.0,
                                                  spreadRadius: 10,
                                                ),
                                              ]
                                            : [],
                                      ),
                                    ),
                                    Image.asset(
                                      actionButtons[index].iconsPath,
                                      width: 80.r,
                                      height: 80.r,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ],
                                ),
                              )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
