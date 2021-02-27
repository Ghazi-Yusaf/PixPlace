import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:image/image.dart';

void blurFacePictures(File file) async {
  String url = "176.58.121.80:5000";

  var request = http.MultipartRequest(
    "POST",
    Uri.http(url, "/"),
  );

  request.headers["Content-Type"]='multipart/form-data';

  request.files.add(
    http.MultipartFile.fromBytes(
      "image",
      file.readAsBytesSync(),
    //   contentType: MediaType(
    //       "image", "${image.path.split(".").last}"),
    ),
  );

  var response = await request.send();



  await response.stream.toList().then((value) {
    List<int> newbyteStream = value.expand((element) => element).toList();
    print(newbyteStream);
    Image image = decodeJpg(newbyteStream);

    File('thumbnail.jpg')..writeAsBytesSync(encodePng(image));
  });

  // EXAMPLE
  //https://pub.dev/packages/image

  






  // print(response.statusCode);
  // print(response.toString());
  //
  // print(response.headers);
  print(response.stream.toString());
}


void main() {
  String filePath = Directory.current.path+"\\lib\\firebase\\services\\meme.png";

  File file = new File(filePath);

  blurFacePictures(file);
}





