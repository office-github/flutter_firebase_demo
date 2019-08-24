import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  final String text;

  QrGenerator(this.text);

  @override
  State<StatefulWidget> createState() {
    return _QrGeneratorState(this.text);
  }
}

class _QrGeneratorState extends State<QrGenerator> {
  final String text;
  TextEditingController textEditingController = new TextEditingController();

  _QrGeneratorState(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(child: getForm(context));
  }

  Widget getForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.text),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: QRCodeImage(this.text)
    );
  }
}

class QRCodeImage extends StatelessWidget {
  final double finalSize = 400;
  final String text;

  QRCodeImage(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: new QrImage(
              data: text,
              size: finalSize,
            ));
  }
}
