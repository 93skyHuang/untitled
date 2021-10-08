import 'package:flutter/material.dart';
import 'package:untitled/widget/custom_text.dart';

class VerifiedPage extends StatefulWidget {
  const VerifiedPage();

  @override
  State<VerifiedPage> createState() => _VerifiedPageState();
}

class _VerifiedPageState extends State<VerifiedPage> {
  final TextEditingController idTextFieldController = TextEditingController();
  final TextEditingController nameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: new IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title:
            Text("实名认证", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF5F5F5),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50, bottom: 20),
              child: Image(
                image: AssetImage("assets/images/icon_id_veriffy.png"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/icon_safe.png"),
                ),
                CustomText(
                  text: '陌声承诺保障您的隐私安全，且只会用于实名认证。',
                  margin: EdgeInsets.only(left: 3),
                  textStyle: TextStyle(fontSize: 12, color: Color(0xff6D2077)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10, left: 38, right: 38),
              child: TextField(
                controller: idTextFieldController,
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.5),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Color(0xFFA9B3BB), fontSize: 15),
                  hintText: "输入身份证号",
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20, left: 38, right: 38),
              child: TextField(
                controller: nameTextFieldController,
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.5),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Color(0xFFA9B3BB), fontSize: 15),
                  hintText: "输入姓名",
                  contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
              },
              child: Container(
                width: 214,
                height: 40,
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  border: new Border.all(width: 1, color: Color(0xff8C8C8C)),
                ),
                child: Text('提交认证',
                    style: TextStyle(color: Color(0xff8C8C8C), fontSize: 17)),
              ),
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
