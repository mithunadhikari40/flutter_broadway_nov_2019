import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;

import 'models/image_model.dart';
import 'widgets/image_list.dart';

class App extends StatefulWidget {
  @override
  createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  int count = 0;

  List<ImageModel> images = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
//        if(images.length==0) then show some text
//        else show the images

        body: images.length == 0
            ? Text("Press the rounded button to fetch some images")
            : ImageList(images),
        appBar: AppBar(
          title: Text("Image app!"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImages,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  getImages() async {
    count++; //count =count +1;
    //fetch some image from the server and show on the mobile screen
    final response =
        await get("https://jsonplaceholder.typicode.com/photos/$count");
    final data = jsonDecode(response.body);
    final imageModel = ImageModel.fromJson(data);

    setState(() {
      images.add(imageModel);
    });
  }
}
