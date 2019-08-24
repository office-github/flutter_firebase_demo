import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter_firebase_demo/book/book_ticket.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:flutter_firebase_demo/user/current_user.dart';

List<CameraDescription> cameras;

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class QRReader extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<QRReader> with SingleTickerProviderStateMixin {
  QRReaderController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameraList) {
      cameras = cameraList;
      animationController = new AnimationController(
        vsync: this,
        duration: new Duration(seconds: 3),
      );

      animationController.addListener(() {
        this.setState(() {});
      });
      animationController.forward();
      verticalPosition = Tween<double>(begin: 0.0, end: 300.0).animate(
          CurvedAnimation(parent: animationController, curve: Curves.linear))
        ..addStatusListener((state) {
          if (state == AnimationStatus.completed) {
            animationController.reverse();
          } else if (state == AnimationStatus.dismissed) {
            animationController.forward();
          }
        });

      // pick the first available camera
      onNewCameraSelected(cameras[0]);
    }).catchError((e, s) {
      logError(e.code, e.description);
      showMessageDialog(
          context: context,
          title: "Error",
          message: "Failed to read QR Code. Please try again.",
          type: MessageType.error);
    });
  }

  Animation<double> verticalPosition;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.check),
          onPressed: () {
            showInSnackBar(
                "Just proving you can put anything on top of the scanner");
          },
        ),
        body: Stack(
          children: <Widget>[
            new Container(
              child: new Padding(
                padding: const EdgeInsets.all(0.0),
                child: new Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 300.0,
                    width: 300.0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2.0)),
                    ),
                  ),
                  Positioned(
                    top: verticalPosition.value,
                    child: Container(
                      width: 300.0,
                      height: 2.0,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'No camera selected',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new QRReaderPreview(controller),
      );
    }
  }

  void onCodeRead(dynamic value) {
    //showInSnackBar(value.toString());
    // ... do something
    // wait 5 seconds then start scanning again.
    if(CurrentUser.amount < 1 && CurrentUser.bonus < 1) {
      showMessageDialog(
        context: context,
        title: "Balance Information",
        message: "Insufficient Balance",
        type: MessageType.error
      );
      return;
    }

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      debugPrint("Book Ticket Navigation.");
      return BookTicket(value.toString());
    }));
    new Future.delayed(const Duration(seconds: 5), controller.startScanning);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new QRReaderController(cameraDescription, ResolutionPreset.low,
        [CodeFormat.qr, CodeFormat.pdf417], onCodeRead);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });
    bool isPermissionGranted = false;
    while (!isPermissionGranted) {
      try {
        await controller.initialize();
        isPermissionGranted = true;
      } on QRReaderException catch (e) {
        logError(e.code, e.description);
        //showInSnackBar('Error: ${e.code}\n${e.description}');
      }
    }

    if (mounted) {
      setState(() {});
      controller.startScanning();
    }
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
