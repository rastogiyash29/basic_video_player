import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/components/video_card.dart';
import 'package:basic_video_player/models/video_specs.dart';
import 'package:basic_video_player/screens/camera.dart';
import 'package:basic_video_player/screens/video_opener.dart';
import 'package:basic_video_player/utils/constants.dart';

class AllRecordingScreen extends StatefulWidget {
  static const id = "all_recording_screen";

  const AllRecordingScreen({super.key});

  @override
  State<AllRecordingScreen> createState() => _AllRecordingScreenState();
}

class _AllRecordingScreenState extends State<AllRecordingScreen> {
  TextEditingController _controller = TextEditingController();
  String searchKey = "";
  bool isFilterOn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 10.0,
              shadowColor: primaryColor,
              stretch: true,
              stretchTriggerOffset: 150.0,
              pinned: true,
              floating: true,
              snap: true,
              title: Text(
                'All Videos',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: primaryColor,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: <Color>[primaryColor, Colors.transparent],
                    ),
                  ),
                  position: DecorationPosition.foreground,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://www.holidify.com/images/bgImages/SATTAL.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _controller,
                            onChanged: (value){
                              if(isFilterOn){
                                setState(() {

                                });
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              suffixIcon: IconButton(
                                icon:
                                isFilterOn ? Icon(Icons.close) : Icon(Icons.search),
                                onPressed: () {
                                  if (isFilterOn) {
                                    _controller.text="";
                                  } else {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  }
                                  setState(() {
                                    isFilterOn = !isFilterOn;
                                  });
                                },
                              ),
                              hintText: 'Search by video category',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                stretchModes: [StretchMode.blurBackground],
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, CameraScreen.id);
                  },
                  icon: const Icon(
                    Icons.video_call_sharp,
                  ),
                  color: Colors.greenAccent,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => getAlertDialog(context));
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ];
        },
        body: isFilterOn
            ? streamBuilder(FirebaseFirestore.instance
            .collection(videosFirestoreCollection)
            .where('videoCategory', isEqualTo: _controller.text.toString())
            .snapshots())
            : streamBuilder(FirebaseFirestore.instance
            .collection(videosFirestoreCollection)
            .snapshots()),
      ),
    );
  }

  Widget getAlertDialog(context) {
    return AlertDialog(
      title: const Text('Exit'),
      content: const Text('Do you want to Exit?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text('Yes'),
        ),
      ],
      elevation: 24.0,
    );
  }

  Widget streamBuilder(Stream<QuerySnapshot<Object?>> dataStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: dataStream,
      builder: (context, snapshot) {
        List<VideoSpecs> allVideos = [];
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final videos = snapshot.data!.docs;
        for (var video in videos) {
          allVideos.add(VideoSpecs(
              videoName: video.get('videoName'),
              url: video.get('url'),
              videoCategory: video.get('videoCategory'),
              videoDescription: video.get('videoDescription')));
        }
        return allVideos.length == 0
            ? const Center(
          child: Text(
            'No video',
            style: largeMessageTextStyle,
            textAlign: TextAlign.center,
          ),
        )
            : ListView.builder(
          itemCount: allVideos.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            void onDeleteCurrentVideo() {
              final refrence = FirebaseStorage.instance
                  .refFromURL(allVideos[index].url);
              refrence.delete();
              FirebaseFirestore.instance
                  .collection(videosFirestoreCollection)
                  .where('url', isEqualTo: allVideos[index].url)
                  .get()
                  .then(
                    (value) => {
                  for (var doc in value.docs)
                    {
                      FirebaseFirestore.instance
                          .collection(videosFirestoreCollection)
                          .doc(doc.id)
                          .delete()
                    }
                },
              );
            }

            return VideoCard(
              video: allVideos[index],
              key: UniqueKey(),
              onEdit: () {
                Navigator.pushNamed(
                  context,
                  VideoOpener.id,
                  arguments: {
                    'video': allVideos[index],
                    'onDelete': onDeleteCurrentVideo,
                    'onEditAndSave': (String newName, String newDesc,
                        String newCategory) {
                      FirebaseFirestore.instance
                          .collection(videosFirestoreCollection)
                          .where('url', isEqualTo: allVideos[index].url)
                          .get()
                          .then(
                            (value) => {
                          for (var doc in value.docs)
                            {
                              FirebaseFirestore.instance
                                  .collection(
                                  videosFirestoreCollection)
                                  .doc(doc.id)
                                  .update({
                                'videoName': newName,
                                'videoDescription': newDesc,
                                'videoCategory': newCategory
                              })
                            }
                        },
                      );
                    }
                  },
                );
              },
              onDelete: onDeleteCurrentVideo,
            );
          },
        );
      },
    );
  }
}

const largeMessageTextStyle = TextStyle(
    color: secondaryColor, fontWeight: FontWeight.normal, fontSize: 30.0);
