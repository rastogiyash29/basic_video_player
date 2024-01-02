import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/screens/all_recording.dart';
import 'package:basic_video_player/utils/constants.dart';

class UploadingScreen extends StatefulWidget {
  static const id = 'upload_screen';

  final String filePath,
      videoName,
      videoDescription,
      videoCategory,
      createdTimeStamp;

  UploadingScreen(
      {required this.filePath,
      required this.videoName,
      required this.createdTimeStamp,
      required this.videoCategory,
      required this.videoDescription,
      });

  @override
  State<UploadingScreen> createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  bool isUploaded = false;
  bool isFailed = false;
  String currentMessage = uploadingMessage;
  final firebaseStorage = FirebaseStorage.instance.ref(videoStorageReference);
  final firebaseDatabase = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      uploadVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            if (isUploaded || isFailed) {
              Navigator.pop(context);
              return;
            }
            showDialog(
                context: context,
                builder: (context) => getAlertDialog(context));
          },
        ),
        title: Text('Uploading'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isFailed
              ? Icon(
                  Icons.error,
                  color: Colors.redAccent,
                  size: 100.0,
                )
              : !isUploaded
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Icon(
                      Icons.done,
                      color: Colors.greenAccent,
                      size: 100.0,
                    ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            currentMessage,
            style: uploadScreenMessageTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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

  String _generateRandomId() {
    var bytes = Uint8List(16);
    var random = Random.secure();
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    return base64Url.encode(bytes);
  }

  void uploadVideo() async {
    isFailed = false;
    isUploaded = false;
    String uniqueIdentifier = _generateRandomId();

    String fileName =
        '$uniqueIdentifier${widget.createdTimeStamp}.${widget.filePath.substring(widget.filePath.lastIndexOf("."))}';
    try {
      final reference = firebaseStorage.child(fileName);
      TaskSnapshot uploadTask = await reference.putFile(File(widget.filePath));
      final String downloadUrl = await uploadTask.ref.getDownloadURL();

      await firebaseDatabase.collection(videosFirestoreCollection).add({
        "videoName": widget.videoName,
        "videoDescription":widget.videoDescription,
        "videoCategory":widget.videoCategory,
        "url": downloadUrl,
        "fileName":fileName
      });

      setState(() {
        isUploaded = true;
        currentMessage = uploadSuccessMessage;
      });
    } catch (e) {
      dev.log('upload failed with error', error: e.toString());
      setState(() {
        isFailed = true;
        isUploaded = false;
        currentMessage = uploadErrorMessage;
      });
    }
  }
}

const String uploadSuccessMessage = 'Video Uploaded Successfully';
const String uploadingMessage = 'Video is Uploading';
const String uploadErrorMessage =
    'Error while uploading video, Please try again';
