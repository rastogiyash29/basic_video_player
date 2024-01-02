import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:basic_video_player/models/video_specs.dart';
import 'package:basic_video_player/screens/all_recording.dart';
import 'package:basic_video_player/utils/constants.dart';

class VideoCard extends StatefulWidget {
  VideoSpecs video;
  Function onEdit;
  Function onDelete;

  VideoCard(
      {super.key,
      required this.video,
      required this.onEdit,
      required this.onDelete});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _videoPlayerController;

  late CustomVideoPlayerController _customVideoPlayerController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  bool loadingVideo = false;

  @override
  void initState() {
    super.initState();
    loadingVideo = true;
    //initialize player
    initializePlayer(widget.video.url);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
  }

  //Initialize Video Player
  void initializePlayer(String url) async {
    print('loading');
    final fileInfo = await checkCacheFor(url);
    print('checking cache');
    if (fileInfo == null) {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      _videoPlayerController!.initialize().then((value) {
        cachedForUrl(url);
        setState(() {
          _videoPlayerController!.play();
        });
      });
    } else {
      final file = fileInfo.file;
      _videoPlayerController = VideoPlayerController.file(file);
      _videoPlayerController!.initialize().then((value) {
        setState(() {
          _videoPlayerController!.play();
        });
      });
    }

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );

    setState(() {
      print('loaded');
      loadingVideo = false;
    });
  }

  //: check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    print('doneeee');
    return value;
  }

//:cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade700,
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.video.videoName,
                        style: cardNameTextStyle, overflow: TextOverflow.fade),
                    Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          widget.onEdit();
                        },
                        icon: Icon(
                          Icons.edit,
                          color: primaryColor,
                          size: 25.0,
                        )),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                        size: 25.0,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => getAlertDialog(context));
                      },
                    ),
                  ],
                ),
                Text(
                  widget.video.videoCategory,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ExpandableText(
                  widget.video.videoDescription,
                  textAlign: TextAlign.start,
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 1,
                  linkColor: Colors.blue,
                ),
              ],
            ),
          ),
          Container(
            color: secondaryColor,
            height: 400.0,
            child: loadingVideo
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
          ),
        ],
      ),
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

const cardNameTextStyle = TextStyle(
    color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.normal);
