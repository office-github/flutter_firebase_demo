import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QrGeneratorState();
  }
}

class _QrGeneratorState extends State<QrGenerator> {
  TextEditingController textController = TextEditingController();
  TextEditingController sizeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(child: getForm(context));
  }

  Widget getForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Generator"),
        leading: IconButton(
          icon: Icon(Icons.movie),
          onPressed: null,
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
            child: TextField(
              keyboardType: TextInputType.text,
              textDirection: TextDirection.ltr,
              controller: sizeController,
              decoration: InputDecoration(
                  labelText: "Enter QR Code Size",
                  hintText: "Enter Size of the QR Code",
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
                String size = sizeController.text;

                if (text.isNotEmpty && size.isNotEmpty) {
                  double finalSize = double.parse(size);
                  if (finalSize < 150 || finalSize > 700) {
                    finalSize = 300;
                  }

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    debugPrint("Size: $finalSize, text: $text");
                    return QRCodeImage(finalSize, text);
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
  double finalSize = 0;
  String text = "QR Code";

  QRCodeImage(this.finalSize, this.text);

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