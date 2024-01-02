import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/components/rounded_button.dart';
import 'package:basic_video_player/screens/all_recording.dart';
import 'package:basic_video_player/screens/camera.dart';
import 'package:basic_video_player/screens/uploadingScreen.dart';

class RecordedVideoPreview extends StatefulWidget {
  static const id = "recorded_video_screen";

  final String filePath;

  const RecordedVideoPreview({required this.filePath});

  @override
  State<RecordedVideoPreview> createState() => _RecordedVideoPreviewState();
}

class _RecordedVideoPreviewState extends State<RecordedVideoPreview> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  String videoName = "";
  String videoDescription = "";
  String videoCategory = "";
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return getAlertDialog(context);
              },
            );
          },
        ),
        title: const Text('New Video'),
        elevation: 0,
        // backgroundColor: Colors.black26,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: textFieldDecoration.copyWith(hintText: 'Name'),
                onChanged: (value) {
                  videoName = value;
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration:
                    textFieldDecoration.copyWith(hintText: 'Description'),
                onChanged: (value) {
                  videoDescription = value;
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: textFieldDecoration.copyWith(hintText: 'Category'),
                onChanged: (value) {
                  videoCategory = value;
                },
              ),
            ),
            Expanded(
              child: CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RoundedButton(
                      color: Colors.red,
                      label: 'Delete',
                      callback: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return getAlertDialog(context);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: RoundedButton(
                      color: Colors.teal,
                      label: 'Retake',
                      callback: () {
                        retakeVideo(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: RoundedButton(
                      color: Colors.greenAccent,
                      label: 'Save',
                      callback: () {
                        saveVideo(context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveVideo(context) async {
    if (videoName.isEmpty ||
        videoDescription.isEmpty ||
        videoCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Name, Description, Category cannot be empty'),
      ));
      return;
    }


    Navigator.popAndPushNamed(context, UploadingScreen.id, arguments: {
      'filePath':widget.filePath,
      'videoName': videoName,
      'videoDescription': videoDescription,
      'videoCategory':videoCategory,
      'createdTimeStamp':DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  void retakeVideo(context) {
    Navigator.popAndPushNamed(context, CameraScreen.id);
  }

  Widget getAlertDialog(context) {
    return AlertDialog(
      title: const Text('Cancel'),
      content: const Text('Do you want to return without saving video?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.popUntil(context,
                (route) => route.settings.name == AllRecordingScreen.id);
          },
          child: const Text('Yes'),
        ),
      ],
      elevation: 24.0,
    );
  }
}

const textFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
  hintText: 'Enter a video description',
  hintStyle: TextStyle(color: Colors.grey),
);
