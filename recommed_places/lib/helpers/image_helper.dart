import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHelper {
//compress a file and get a List<int>
  static Future<List<int>> getIntegerListFromFile(
      File file, int quality) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: quality,
    );
    return Uint8List.fromList(result);
  }

  // 2. compress file and get file.
  static Future<File> getCompressedFileFromFile(
      File file, String targetPath, int quality) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  // 3. compress asset and get List<int>.
  static Future<List<int>> getListFromAssets(
      String assetName, int quality) async {
    var list = await FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: 1920,
      minWidth: 1080,
      quality: quality,
      rotate: 180,
    );

    return Uint8List.fromList(list);
  }

  // 4. compress List<int> and get another List<int>.
  static Future<List<int>> getListFromList(List<int> list, int quality) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: quality,
      rotate: 135,
    );
    print(list.length);
    print(result.length);
    return Uint8List.fromList(result);
  }

  static bool fileExists(String imagePath) {
    return FileSystemEntity.typeSync(imagePath) !=
        FileSystemEntityType.notFound;
  }
}
