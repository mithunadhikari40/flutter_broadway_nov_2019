import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recommed_places/base/base_model.dart';
import 'package:recommed_places/core/models/places.dart';
import 'package:recommed_places/core/services/home_service.dart';
import 'package:recommed_places/helpers/location_helper.dart';

class HomeViewModel extends BaseModel {
  final HomeService homeService;

  List<Place> get places => homeService.places;

  HomeViewModel({@required  this.homeService}){
    checkInternetConnection();
  }
  getAllPlaces() async {
    setBusy(true);
    await homeService.getAllPlaces();
    setBusy(false);
  }

  Place getPlaceById(String id) {
    return homeService.getPlaceById(id);
  }

  Future<void> savePlace(String text, String imagePath, LatLng location) async {
    setBusy(true);
    final String address = await LocationHelper.getFinePlaceAddress(location);
    Place place = Place(
      id: DateTime.now().toIso8601String(),
      title: text,
      address: address,
      imagePath: imagePath,
      latitude: location.latitude,
      longitude: location.longitude,
      isSynced: 0,
      serverImagePath: null
    );

    await homeService.savePlace(place);
    setBusy(false);
  }

  Future wipeLocalData() async {
    setBusy(true);
    await homeService.wipeLocalData();
    setBusy(false);
  }

  Future getAllDataFromServer() async {
    setBusy(true);
    await homeService.getAllDataFromServer();
    setBusy(false);
  }


  ConnectivityResult get connectivity => _connectivity;

  ConnectivityResult _connectivity = ConnectivityResult.none;


  checkInternetConnection() {
    Connectivity().onConnectivityChanged.listen((value) {
      _connectivity = value;
      notifyListeners();
    });
  }

  void syncAllData() {
    homeService.syncAllData();
  }

  Place findById(String id) {
    return homeService.findPlaceById(id);

  }
}
