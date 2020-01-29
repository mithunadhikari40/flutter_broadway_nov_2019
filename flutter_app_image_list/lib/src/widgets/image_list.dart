import 'package:flutter/material.dart';
import 'package:flutter_app/src/models/image_model.dart';

class ImageList extends StatelessWidget {
  ImageList(this.images);

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              Image.network(images[index].url),
              Padding(
                padding: EdgeInsets.only(top: 12, left: 12),
                child: Text(
                  images[index].title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.pink,
              width: 4,
            ),
          ),
        );
      },
    );
  }
}
