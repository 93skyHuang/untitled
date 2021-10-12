import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();
///
Future<XFile?> getImageFromGallery() async {
  XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image;
}


Future<XFile?> getVideoFromGallery() async {
  XFile? video = await _picker.pickImage(source: ImageSource.gallery);
  return video;
}

Future<XFile?> getPhoto() async {
  XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  return photo;
}

Future<XFile?> getVideo() async {
  XFile? video = await _picker.pickImage(source: ImageSource.camera);
  return video;
}

Future<List<XFile>?> getImages() async {
  List<XFile>? images = await _picker.pickMultiImage();
  return images;
}
