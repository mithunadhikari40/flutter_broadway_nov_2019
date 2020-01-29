class Place {
  String id;
  String title;
  String address;
  String imagePath;
  double latitude;
  double longitude;
  int isSynced;
  String serverImagePath;


  Place({this.id, this.title, this.address, this.imagePath, this.latitude,
      this.longitude , this.isSynced, this.serverImagePath});

  Place.fromJson(Map<dynamic, dynamic> map) {
    id = map["id"];
    title = map["title"];
    address = map["address"];
    imagePath = map["imagePath"];
    latitude = map["latitude"];
    longitude = map["longitude"];
    serverImagePath = map["serverImagePath"];
    isSynced = map["isSynced"];
  }

  toJson() {
    return {
      "id": id,
      "title": title,
      "address": address,
      "imagePath": imagePath,
      "latitude": latitude,
      "longitude": longitude,
      "serverImagePath": serverImagePath,
      "isSynced": isSynced
    };
  }

  @override
  bool operator ==(other) {
     return this.id==other.id
        && this.title==other.title &&
    this.address == other.address &&
    this.latitude ==other.latitude &&
    this.longitude == other.longitude &&
    this.serverImagePath == other.serverImagePath;
  }

  @override
  int get hashCode {
    return 84379543;
  }


}
