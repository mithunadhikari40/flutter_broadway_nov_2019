import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final Function(LatLng latLng) onLocationCallback;
  final LatLng currentLocation;
  final bool selectOnMap;

  const MapView({this.onLocationCallback,
    this.currentLocation = const LatLng(27.34, 85.342),
    this.selectOnMap});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng _pickedLocation;

  @override
  Widget build(BuildContext context) {
    print("The gotten currentLocation are ${widget.currentLocation}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Your map"),
        actions: <Widget>[
          !widget.selectOnMap
              ? Container()
              : IconButton(
            icon: Icon(
              Icons.check,
              color: Theme
                  .of(context)
                  .secondaryHeaderColor,
            ),
            onPressed: _pickedLocation == null
                ? null
                : () {
              widget.onLocationCallback(_pickedLocation);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _buildGoogleMap(context),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation ?? const LatLng(27.34, 85.342),
        zoom: 15.0,
      ),
      onTap: widget.selectOnMap ? _selectLocation : null,
      markers: {
        Marker(
            markerId: MarkerId(_pickedLocation == null
                ? widget.currentLocation.toString()
                : _pickedLocation.toString()),
            position: _pickedLocation ?? widget.currentLocation)
      },
    );
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }
}
