import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/screens/all_recording.dart';
import 'package:basic_video_player/screens/camera.dart';
import 'package:basic_video_player/screens/recorder_video_preview.dart';
import 'package:basic_video_player/screens/splash_screen.dart';
import 'package:basic_video_player/screens/uploadingScreen.dart';
import 'package:basic_video_player/screens/video_opener.dart';
import 'package:basic_video_player/utils/constants.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Video Player',
    theme: ThemeData(
      appBarTheme: AppBarTheme().copyWith(
        iconTheme: IconThemeData().copyWith(color: Colors.white, size: 25.0),
        color: primaryColor,
        titleTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 25.0),
      ),
    ),
    initialRoute: SplashScreen.id,
    routes: {
      AllRecordingScreen.id: (context) => AllRecordingScreen(),
      CameraScreen.id: (context) => CameraScreen(),
      SplashScreen.id: (context) => SplashScreen(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == RecordedVideoPreview.id) {
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) {
            return RecordedVideoPreview(
              filePath: args,
            );
          },
        );
      } else if (settings.name == UploadingScreen.id) {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return UploadingScreen(
              filePath: args['filePath'],
              videoName: args['videoName'],
              videoDescription: args['videoDescription'],
              videoCategory: args['videoCategory'],
              createdTimeStamp: args['createdTimeStamp'],
            );
          },
        );
      } else if (settings.name == VideoOpener.id) {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return VideoOpener(
              video: args['video'],
              onDelete: args['onDelete'],
              onEditAndSave: args['onEditAndSave'],
            );
          },
        );
      }
    },
  ));
}
