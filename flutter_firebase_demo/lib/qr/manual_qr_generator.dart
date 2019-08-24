import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/dialog/dialog.dart';
import 'package:flutter_firebase_demo/general/back.dart';
import 'package:flutter_firebase_demo/general/message_type.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ManualQRGeneratorState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManualQRGeneratorState();
  }
}

class _ManualQRGeneratorState extends State<ManualQRGeneratorState> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(child: getForm(context));
  }

  Widget getForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Generator"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => back(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.text,
              textDirection: TextDirection.ltr,
              controller: textController,
              decoration: InputDecoration(
                  labelText: "Enter Text",
                  hintText: "Enter text to generate QR Code",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text("Generate QR Code"),
              onPressed: () {
                String text = textController.text;
                if (text.isEmpty || !text.contains(",")) {
                  showMessageDialog(
                      context: context,
                      title: "Error",
                      message:
                          "Please provide text as bus number, name.\n-----------------------\nExample: BA 12 KHA 1111, Shubhakamana Yatayat",
                      type: MessageType.error);
                } else if (text.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    debugPrint("text: $text");
                    return QRCodeImage(text);
                  }));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class QRCodeImage extends StatelessWidget {
  final double finalSize = 350;
  final String text;

  QRCodeImage(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
            appBar: AppBar(
              title: Text(text),
            ),
            body: new QrImage(
              data: text,
              size: finalSize,
            )));
    ;
  }
}
