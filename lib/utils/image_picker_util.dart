import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final ImagePicker _picker = ImagePicker();

///从相册中获取图片
Future<XFile?> getImageFromGallery() async {
  XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image;
}

///从相册中获取视频
Future<XFile?> getVideoFromGallery() async {
  XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery, maxDuration: const Duration(seconds: 30));
  return video;
}

Future<XFile?> getPhoto() async {
  XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  return photo;
}

Future<XFile?> getVideo() async {
  XFile? video = await _picker.pickVideo(
      source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
  return video;
}

Future<List<XFile>?> getImages() async {
  List<XFile>? images = await _picker.pickMultiImage();
  return images;
}

/**
 * 获取视频第一帧
 */
Future<String> getVideoImage(String videoUrl) async {
  String? thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl, imageFormat: ImageFormat.JPEG);
  return thumbnailPath??'';
}
