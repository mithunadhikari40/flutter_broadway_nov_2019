import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:http/http.dart' show get;

class LocationHelper {
  static const String mapBoxApiKey =
      "your mapbox key here";

  static String generateLocationPreviewImage(LatLng latLng) {
    final url =
        "https://api.mapbox.com/v4/mapbox.emerald/${latLng.longitude},${latLng.latitude},16/600x300@2x.png?access_token=$mapBoxApiKey";
    return url;
  }

//
//  static Future<String> getPlaceAddress(LatLng latLng) async {
//    try {
//      final coordinates = new Coordinates(latLng.longitude, latLng.longitude);
//      List<Address> addresses =
//          await Geocoder.local.findAddressesFromCoordinates(coordinates);
//      Address address = addresses.first;
//      return '${address.locality} , ${address.subLocality}';
//    } catch (err) {
//      print("Error while fetching address is $err");
//      return 'Could not find any place';
//    }
//  }

  static Future<String> getFinePlaceAddress(LatLng latLng) async {
    try {
      final mapBoxUrl =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/${latLng.longitude},${latLng.latitude}.json?access_token=$mapBoxApiKey";
      print("The hitten url is $mapBoxUrl");
      final response = await get(mapBoxUrl);
      final data = jsonDecode(response.body);
      if (data['features'] == null) {
        return "No address found";
      }

      String address = data["features"][0]['place_name'];
      final List<String> addressList = address?.split(",");
      return addressList[0] + " " + addressList[1];
    } catch (err) {
      return "No address found";
    }
  }
}
