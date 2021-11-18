import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:untitled/basic/include.dart';

/**
 * 图片显示
 * 跳转代码
 *       Get.toNamed(photoViewPName, arguments: {
    'index': 1,
    'photoList': [
    'http://sancunkongjian.oss-cn-beijing.aliyuncs.com/TIS/20200418/2020041821385320771.jpg',
    'http://sancunkongjian.oss-cn-beijing.aliyuncs.com/TIS/20200418/2020041821385320771.jpg',
    'http://sancunkongjian.oss-cn-beijing.aliyuncs.com/TIS/20200418/2020041821385320771.jpg',
    'http://sancunkongjian.oss-cn-beijing.aliyuncs.com/TIS/20200418/2020041821385320771.jpg',
    ]
    });
 */
/**
 * 显示图片群
 */
class PhotoViewPage extends StatefulWidget {
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  int currentIndex = 0;
  int initialIndex = 0; //初始index
  int length = 0;
  int title = 0;
  List photoList = [];

  @override
  void initState() {
    final details = Get.arguments as Map;

    currentIndex = details['index'];
    initialIndex = currentIndex;
    photoList = details['photoList'];
    length = photoList.length;
    title = initialIndex + 1;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
      title = index + 1;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColor.pageBgColor,
          // title: Text(
          //   '$title / $length',
          //   style: TextStyle(color: Colors.black),
          // ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.chevron_left, size: 38, color: Colors.white),
              onPressed: () {
                Get.back();
              })),
      body: Container(
          decoration: BoxDecoration(
            color: MyColor.pageBgColor,
          ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollDirection: Axis.horizontal,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(photoList[index]),
                    initialScale: PhotoViewComputedScale.contained * 1,
                    heroAttributes: PhotoViewHeroAttributes(tag: currentIndex),
                  );
                },
                itemCount: photoList.length,
                // loadingChild: widget.loadingChild,
                backgroundDecoration: const BoxDecoration(
                  color: MyColor.pageBgColor,
                ),
                pageController: PageController(initialPage: initialIndex),
                //点进去哪页默认就显示哪一页
                onPageChanged: onPageChanged,
              ),
            ],
          )),
    );
  }
}

///单一图片缩放
class PhotoViewScalePage extends StatefulWidget {
  @override
  _PhotoViewScalePageState createState() => _PhotoViewScalePageState();
}

class _PhotoViewScalePageState extends State<PhotoViewScalePage> {
  @override
  String url = '';

  @override
  void initState() {
    final details = Get.arguments as Map;
    url = details['url'];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(url),
    ));
  }
}
