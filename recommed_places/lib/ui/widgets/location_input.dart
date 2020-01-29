import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:recommed_places/core/constants/app_contstants.dart';
import 'package:recommed_places/helpers/location_helper.dart';
import 'package:recommed_places/ui/shared/ui_helpers.dart';
class LocationInput extends StatefulWidget {
  final Function(LatLng) onSelectLocation;

  const LocationInput({Key key, this.onSelectLocation}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImage;
  LatLng _currentLocation;

  @override
  void initState() {
    super.initState();
    Location().onLocationChanged().listen((LocationData data) {
      updateLocation(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          width: size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              color: Colors.brown,
            ),
          ),
          child:
              /* _isBusy
              ? CircularProgressIndicator()
              :*/
              _previewImage == null
                  ? Text("No location choosen")
                  : Image.network(
                      _previewImage,
                      fit: BoxFit.cover,
                      width: size.width,
                      loadingBuilder: _loadNetworkImageBuilder,
                    ),
        ),
        UIHelper.verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              onPressed: _getCurrentLocation,
              label: Text("Current location"),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              onPressed: _selectOnMap,
              label: Text("Select on map"),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final LocationData locationData = await Location().getLocation();
      final LatLng latLng =
          LatLng(locationData.latitude, locationData.longitude);
      _showPreview(latLng);
      widget.onSelectLocation(latLng);
    } catch (err) {
      return;
    }
  }

  void _selectOnMap() {
    Navigator.of(context).pushNamed(RoutePaths.Map,
        arguments: [onLocationCallback, _currentLocation, true]);
  }

  void onLocationCallback(LatLng latLng) {
    _showPreview(latLng);
    widget.onSelectLocation(latLng);
  }

  void _showPreview(LatLng latLng) {
    final staticMapImage = LocationHelper.generateLocationPreviewImage(latLng);
    print("The image we get is $staticMapImage");
    setState(() {
      _previewImage = staticMapImage;
    });
  }

  void updateLocation(LocationData data) {
    _currentLocation = LatLng(data.latitude, data.longitude);
  }

  Widget _loadNetworkImageBuilder(
      BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
    print("This thing is getting called over and over again ${child is Image}");
    if (loadingProgress == null)
      return /*child is Image ?*/ child /*: CircularProgressIndicator()*/;
    return CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes
          : null,
    );
  }
}
