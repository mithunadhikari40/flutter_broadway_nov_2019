import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recommed_places/helpers/image_helper.dart';
import 'package:recommed_places/ui/shared/ui_helpers.dart';

class ImageInput extends StatefulWidget {
  final Function(String) onSelectImage;

  const ImageInput({Key key, this.onSelectImage}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future _takePicture() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    image = await ImageHelper.getCompressedFileFromFile(
        image, image.absolute.path, 75);

    if (image == null) {
      final LostDataResponse response = await ImagePicker.retrieveLostData();
      if (response.isEmpty) {
        return;
      }
      if (response.file != null) {
        image = response.file;
      }
    }

    if (image == null) return;
    setState(() {
      _storedImage = image;
    });
    widget.onSelectImage(image.path);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: size.width * .5,
          height: size.height / 4,
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.brown),
          ),
          child: _storedImage == null
              ? Text(
                  "No image taken",
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: size.width,
                ),
        ),
         UIHelper.verticalSpaceSmall,
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            onPressed: _takePicture,
            label: Text("Take picture"),
            textColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
