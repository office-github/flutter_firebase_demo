import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/general/back.dart';

class GridViewMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Grid List';

    return MaterialApp(
        title: title,
        home: WillPopScope(
          onWillPop: () {
            back(context);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  back(context);
                },
              ),
            ),
            body: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(100, (index) {
                return Center(
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headline,
                  ),
                );
              }),
            ),
          ),
        ));
  }
}
