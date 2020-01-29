import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:recommed_places/core/models/places.dart';
import 'package:recommed_places/core/models/user.dart';
import 'package:recommed_places/helpers/image_helper.dart';

/// The service responsible for networking requests
class Api {
  static const endpoint = 'https://jsonplaceholder.typicode.com';
  static const url = "https://recommended-places-fa381.firebaseio.com";

  var client = new http.Client();

  Future<User> getUserProfile(int userId) async {
    // Get user profile for id
    var response = await client.get('$endpoint/users/$userId');

    // Convert and return
    return User.fromJson(json.decode(response.body));
  }

  Future<List<Place>> getAllDataFromServer() async {
    final response = await http.get('$url/places.json');

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body == null) {
      return null;
    }
    List<Place> places = [];
    print("Response while fetching data $body");
    body.forEach((key, value) {
      Place place = Place.fromJson(value as Map<String, dynamic>);
      if (place != null) {
        places.add(place);
      }
    });
    return places;
  }

  Future<void> syncAllData(List<Place> places,  Function(Place,String) onSave) async {
    for (int i = 0; i < places.length; i++) {
      Place place = places[i];

      String serverImagePath = await uploadUsingDio(place.imagePath);
      if (serverImagePath == null) {
        return;
      }

      place.serverImagePath = serverImagePath;
      place.isSynced = 1;

      final response = await http.post(
        '$url/places.json',
        body: jsonEncode(place.toJson()),
      );
      if (response == null) {
        return;
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
final oldId =place.id;
      final id = body["name"];
      place.id = id;

       onSave(place,oldId);

      print("Response while uploading the data to the server $body");
    }
  }

  void getAllData() async {
    /*
    https://recommended-places-fa381.firebaseio.com/
     */

    final response = await http.get(
      '$url/places.json', /* headers: {
        "contentType": "application/json; charset=utf-8",
        'Accept': 'application/json',
        "dataType": "json",
      }*/
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    body.forEach((key, value) {
      final Place pl = Place.fromJson(value);
      print("The casted object is ${pl.toJson()} and key is $key");
    });

    print("Response from firebase ${response.body} get");
  }

  Future uploadImage(Place places) async {
    final title = places.title.replaceAll(" ", "");

    final myApp = "recommended-places-fa381.appspot.com";
    final firebaseUrl = "https://firebasestorage.googleapis.com/v0/b";
    final url = "$firebaseUrl/$myApp/o?name=$title";
    print("The image from our local database ${places.imagePath}");
    print("The urllocal $url");

    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'image', places.imagePath,
//         contentType: MediaType('image', 'jpeg'),
      ));
    var response = await request.send();
    if (response.statusCode == 200) {
      String responseData =
          await response.stream.transform(Utf8Decoder()).join();

      final body = json.decode(responseData);
      print("The body from the response is $body");

      final downloadUrl = "$firebaseUrl/$myApp/o/$title?alt=media";
      print("The downloadable url is $downloadUrl");
    }

    return;

    Map<String, String> dataMap = Map();
    var imageUri = Uri.parse(places.imagePath);
    request = http.MultipartRequest("POST", uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        await File.fromUri(imageUri).readAsBytes(),
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        String responseData =
            await response.stream.transform(Utf8Decoder()).join();

        final downloadUrl = "$firebaseUrl/$myApp/o/${title}?alt=media";
        print("The downloadable url is $downloadUrl");
      } else {
        String responseData =
            await response.stream.transform(Utf8Decoder()).join();

        final downloadUrl = "$firebaseUrl/$myApp/o/${places.id}?alt=media";
        print("The downloadable url is error $downloadUrl");
      }
    } catch (e) {}
  }

  Future<String> uploadUsingDio(String imagePath) async {
    try {
      MultipartFile image = await MultipartFile.fromFile(imagePath,
          filename: "image.jpg", contentType: MediaType('image', 'jpeg'));
      final dio = Dio();
      final formData = FormData.fromMap({
        "key": "67e231173a8282ffb9093898968ce731",
        "age": 25,
        "image": image,
      });
      Response response = await dio.post(
        "https://api.imgbb.com/1/upload",
        data: formData,
      );

      final value = response.data;

      print("The parsed respons is $value");
      var data = value as Map<String, dynamic>;
      var requiredUrl = data["data"]["image"]["url"];
      print("The requuire url is $requiredUrl");
      return requiredUrl;
    } catch (e) {
      print("Error while uploading image $e");
      return null;
    }
  }

  void uploadImageAnotherWay(String imagePath) async {
    try {
      File _image = File(imagePath);
      bool fileExists = ImageHelper.fileExists(imagePath);

      /*var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // get file length
      var length = await _image.length();
      var multipartFile = new http.MultipartFile(
        "image",
        stream,
        length,
        filename: Path.basename(_image.absolute.path),
        contentType: null
       );*/

      // string to uri
      var uri = Uri.parse(
          "http://192.168.10.3:8001/UNDP.RIMS_API/public/saveMultipleImage");
//      var uri = Uri.parse("https://api.imgbb.com/1/upload");

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);
      request.files.add(new http.MultipartFile.fromBytes(
        'image',
        await File.fromUri(Uri.parse(imagePath)).readAsBytes(),
        /* contentType: new MediaType('image', 'jpeg')*/
      ));

      // multipart that takes file

      // add file to multipart
//      request.files.add(multipartFile);

      request.fields["key"] = '67e231173a8282ffb9093898968ce731';

//      request.headers.removeWhere((t,m)=>true);
//    request.fields["username"] = "someone@example.com";

      // send

      print("The parsed respons is yeha samm ta pugeko chha hai");

      var response = await request.send();
      print("The parsed respons is yeha samm ta pugeko chha 2");

      // listen for response
      final value = await response.stream.transform(Utf8Decoder()).join();
      print("The parsed respons is $value");
      var data = jsonDecode(value) as Map<String, dynamic>;
//      var requiredUrl = data["data"]["image"]["url"];
//      print("The response from the image upload server $requiredUrl");
    } catch (e, m) {
      print("The exception caught is ${e} and the stack trace is $m");
      Fluttertoast.showToast(msg: "There was some error during the processing");
    }
  }
}
