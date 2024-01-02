import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/components/rounded_button.dart';

import '../models/video_specs.dart';
import 'all_recording.dart';

class VideoOpener extends StatefulWidget {
  final VideoSpecs video;
  final Function onDelete;
  final Function onEditAndSave;

  VideoOpener(
      {required this.video,
      required this.onDelete,
      required this.onEditAndSave});

  static const id = "video_opener_screen";

  @override
  _VideoOpenerState createState() => _VideoOpenerState();
}

class _VideoOpenerState extends State<VideoOpener> {
  late String currentVideoName;
  late String currentVideoDescription;
  late String currentVideoCategory;

  TextEditingController _videoNameController = new TextEditingController();
  TextEditingController _videoDescriptionController = new TextEditingController();
  TextEditingController _videoCategoryController = new TextEditingController();

  late VideoPlayerController _videoPlayerController;

  late CustomVideoPlayerController _customVideoPlayerController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.url))
          ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );

    currentVideoName = widget.video.videoName;
    currentVideoDescription = widget.video.videoDescription;
    currentVideoCategory = widget.video.videoCategory;

    _videoNameController.text=currentVideoName;
    _videoDescriptionController.text=currentVideoDescription;
    _videoCategoryController.text=currentVideoCategory;
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.video.videoName),
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
                controller: _videoNameController,
                decoration: textFieldDecoration.copyWith(labelText: 'Video Name'),
                onChanged: (value) {
                  currentVideoName = value;
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _videoDescriptionController,
                decoration: textFieldDecoration.copyWith(labelText: 'Video Description'),
                onChanged: (value) {
                  currentVideoDescription = value;
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _videoCategoryController,
                decoration: textFieldDecoration.copyWith(labelText: 'Video Category'),
                onChanged: (value) {
                  currentVideoCategory = value;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RoundedButton(
                        color: Colors.redAccent,
                        label: 'Delete',
                        callback: () {
                          showDialog(
                              context: context,
                              builder: (context) => getAlertDialog(context));
                        }),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: RoundedButton(color: Colors.green, label: 'Save', callback: (){
                      if (currentVideoName.isEmpty||currentVideoDescription.isEmpty||currentVideoCategory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Video Name, Description, Category cannot be empty!!')));
                        return;
                      }
                      if (widget.video.videoName != currentVideoName) {
                        showDialog(
                            context: context,
                            builder: (context) => getSaveAlertDialog(context));
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSaveAlertDialog(context) {
    return AlertDialog(
      title: const Text('Confirm'),
      content: Text('Do you make changes?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            if (widget.video.videoName != currentVideoName) {
              widget.onEditAndSave(currentVideoName,currentVideoDescription,currentVideoCategory);
            }
            Navigator.popUntil(context,
                (route) => route.settings.name == AllRecordingScreen.id);
          },
          child: const Text('Yes'),
        ),
      ],
      elevation: 24.0,
    );
  }

  Widget getAlertDialog(context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text('Do you want to delete this video?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            widget.onDelete();
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
      elevation: 24.0,
    );
  }
}

const textFieldDecoration=InputDecoration(
labelText: 'Outlined',
hintText: 'hint text',
helperText: 'supporting text',
border: OutlineInputBorder(),
);
