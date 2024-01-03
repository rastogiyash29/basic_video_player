import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:basic_video_player/screens/recorder_video_preview.dart';

class CameraScreen extends StatefulWidget {
  static const id="video_recording_screen";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
    // print('initialized ........');
  }

  _recordVideo() async {
    if (_isRecording) {
      // print('Stopped recording ........');
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      Navigator.popAndPushNamed(context, RecordedVideoPreview.id,arguments: file.path);
    } else {
      // print('Started recording ........');
      try{
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
      }catch(E){
        print("error .....");
        print(E.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Record Video'),
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController),
              Padding(
                padding: const EdgeInsets.all(25),
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(_isRecording ? Icons.stop : Icons.circle),
                  onPressed: () => _recordVideo(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
