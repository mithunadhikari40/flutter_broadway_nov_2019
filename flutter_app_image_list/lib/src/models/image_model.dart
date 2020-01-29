class ImageModel {
  int id;
  String title;
  String url;

  ImageModel(this.id, this.title, this.url);

  ImageModel.fromJson(map) {
    id = map["id"];
    title = map["title"];
    url = map["url"];
  }


//  ImageModel.fromJson(map) :
//    id = map["id"],
//    title = map["title"],
//    url = map["url"];


}
