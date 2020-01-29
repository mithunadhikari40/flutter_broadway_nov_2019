import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recommed_places/ui/shared/ui_helpers.dart';
import 'package:recommed_places/ui/widgets/image_input.dart';
import 'package:recommed_places/ui/widgets/location_input.dart';
import 'package:recommed_places/viewmodel/home_view_model.dart';

class AddNewPlace extends StatefulWidget {
  final HomeViewModel model;

  const AddNewPlace({@required this.model});

  @override
  _AddNewPlaceState createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  TextEditingController _controller;
  String _imagePath;
  LatLng _location;

  @override
  Widget build(BuildContext context) {
    return _buildAddNewPlaceSection(context);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  Widget _buildAddNewPlaceSection(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new place"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildTitleField(),
                    UIHelper.verticalSpaceSmall,
                    ImageInput(onSelectImage: _onImageCallBack),
                    UIHelper.verticalSpaceSmall,
                    LocationInput(onSelectLocation: _onLocationCallBack),
                    UIHelper.verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'e.g Tinkue',
      ),
    );
  }

  _onImageCallBack(String imagePath) {
    _imagePath = imagePath;
  }

  Widget _buildSubmitButton(BuildContext context) {
    return FlatButton.icon(
      color: Colors.blue,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        if (_controller.text.isEmpty ||
            _imagePath == null ||
            _location == null) {
          Fluttertoast.showToast(msg: "Please fill the form first");
          return;
        }
        widget.model.savePlace(_controller.text, _imagePath, _location);
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.save),
      label: Text("Save"),
    );
  }

  _onLocationCallBack(LatLng latLng) {
    _location = latLng;
  }
}
