import 'package:flutter/material.dart';


class NicknamePage extends StatefulWidget {
  const NicknamePage();

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController nameTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.5,
          leading: new IconButton(
              icon: Icon(Icons.chevron_left,
                  size: 38, color: Colors.black),
              onPressed: () {
                Navigator.maybePop(context);
              }),
          title:
          Text("昵称", style: TextStyle(fontSize: 17, color: Colors.black)),
          backgroundColor: Color(0xFFF5F5F5),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {},
                child: Text("保存",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, color: Color(0xFFFD4343))),
              ),
            ),
          ]),
      backgroundColor: Color(0xFFF5F5F5),
      body:
      Container(
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
            fillColor: Color(0xffE6E6E6),
            filled: true,
            hintStyle: TextStyle(color: Color(0xFF8C8C8C), fontSize: 15),
            hintText: "请输入昵称（10个字符之内）",
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          ),
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
