import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage();

  @override
  _WebViewPage createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {
  WebViewController? _webViewController;
  String url = '';
  String title = '';

  JavascriptChannel jsBridge(BuildContext context) => JavascriptChannel(
      name: 'jsbridge', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        debugPrint(message.message);
      });

  @override
  Widget build(BuildContext context) {
    final details = Get.arguments as Map;

    url = details['url'];
    title = details['title'];
    return Scaffold(appBar: _buildAppbar(), body: _buildBody());
  }

  _buildAppbar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF5F5F5),
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Get.back();
            }));
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 1,
          width: double.infinity,
          child: const DecoratedBox(
              decoration: BoxDecoration(color: Color(0xFFEEEEEE))),
        ),
        Expanded(
          flex: 1,
          child: WebView(
            // initialUrl: widget.isLocalUrl ? Uri.dataFromString(widget.url, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            //     .toString(): widget.url,
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[jsBridge(context)].toSet(),
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
              // if(widget.isLocalUrl){
              //     _loadHtmlAssets(controller);
              // }else{
              //   controller.loadUrl(widget.url);
              // }
              controller.loadUrl(url);
              controller
                  .canGoBack()
                  .then((value) => debugPrint(value.toString()));
              controller
                  .canGoForward()
                  .then((value) => debugPrint(value.toString()));
              controller.currentUrl().then((value) => debugPrint(value));
            },
            onPageFinished: (String value) {
              _webViewController!
                  .evaluateJavascript('document.title')
                  .then((title) => debugPrint(title));
            },
          ),
        )
      ],
    );
  }

// //加载本地文件
//   _loadHtmlAssets(WebViewController controller) async {
//     String htmlPath = await rootBundle.loadString(widget.url);
//     controller.loadUrl(Uri.dataFromString(htmlPath,mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString());
//   }

}
