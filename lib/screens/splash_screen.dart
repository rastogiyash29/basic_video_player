import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/screens/all_recording.dart';
import 'package:basic_video_player/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static const id='splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {checkUserAndRedirect(context);});
  }

  void checkUserAndRedirect(context) async{
    await Future.delayed(Duration(seconds: 2));
      Navigator.popAndPushNamed(context, AllRecordingScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Video Player',
                textStyle: splashScreentextStyle,
                speed: Duration(milliseconds: 150),
                textAlign: TextAlign.center
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ],
      ),
    );
  }
}
