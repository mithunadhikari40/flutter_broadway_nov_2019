import 'package:flutter/cupertino.dart';
import 'package:recommed_places/core/models/places.dart';
import 'package:recommed_places/core/services/db_provider.dart';

import 'api.dart';

class HomeService {
  final Api _api;
  final DbProvider _dbProvider;

  List<Place> _places = [];

  List<Place> get places => _places;

  HomeService({@required Api api, @required DbProvider dbProvider})
      : _api = api,
        _dbProvider = dbProvider;

  getAllPlaces() async {
    final localPlaces = await _dbProvider.getAllPlaces();
    _places.addAll(localPlaces);
  }

  Place getPlaceById(String id) {
    return _places.firstWhere((Place place) => place.id == id);
  }

  savePlace(Place place) {
    _places.add(place);
    _dbProvider.insertPlace(place);
  }

  Future wipeLocalData() {
    _places = [];
    return _dbProvider.wipeLocalData();
  }

  Future getAllDataFromServer() async {
    List<Place> places = await _api.getAllDataFromServer();
    if (places != null) {
      _places = [..._places, ...places].toSet().toList();
    }
  }

  void syncAllData() async {
    List<Place> places = await _dbProvider.getAllPlaces();
    places = places.where((Place place) => place.isSynced == 0).toList();
    _api.syncAllData(places, onSave);
  }

  Place findPlaceById(String id) {
    return _places.firstWhere((Place place) => place.id == id);
  }

  onSave(Place place,String oldId)  {
     _dbProvider.updatePlace(place,oldId);
  }
}
