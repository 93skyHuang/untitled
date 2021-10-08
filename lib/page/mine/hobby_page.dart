import 'package:flutter/material.dart';
import 'package:untitled/widget/custom_text.dart';
import 'package:untitled/widget/custom_text_15radius.dart';
import 'package:untitled/widget/item_arrow.dart';

class HobbyPage extends StatefulWidget {
  const HobbyPage();

  @override
  State<HobbyPage> createState() => _HobbyPageState();
}

class _HobbyPageState extends State<HobbyPage> {
  List<String> musics = [
    '流行音乐',
    '摇滚音乐',
    '校园歌曲',
    '乡村音乐',
    '古典音乐',
    '金属音乐',
    '影视歌曲',
    'R&B',
    'RAP'
  ];
  List<String> sports = ['跑步', '游泳', '健身', '羽毛球', '篮球', '足球', '滑雪', '攀岩'];
  List<String> movies = ['国产电影', '欧美大片', '日韩剧', '网剧', '国产剧', '好莱坞'];
  List<String> foods = ['中国菜', '日本菜', '西餐', '烘培', '小吃', '零食'];
  List<String> arts = ['唱歌', '跳舞', '表演', '摄影', '绘画', '建筑'];
  List<String> choose = [];

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
              Text("兴趣爱好", style: TextStyle(fontSize: 17, color: Colors.black)),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              text: '音乐',
              margin: EdgeInsets.only(top: 16, left: 16, bottom: 16),
            ),
            Container(
              margin: EdgeInsets.only(left: 11, right: 11),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: musics.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isChoose = choose.contains(musics[index]);
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (isChoose) {
                              choose.remove(musics[index]);
                            } else {
                              choose.add(musics[index]);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color:
                                  isChoose ? Colors.black : Color(0xFFE2E2E2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              musics[index],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color:
                                      isChoose ? Colors.white : Colors.black),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
            CustomText(
              text: '运动',
              margin: EdgeInsets.only(top: 8, left: 16, bottom: 16),
            ),
            Container(
              margin: EdgeInsets.only(left: 11, right: 11),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sports.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isChoose = choose.contains(sports[index]);
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (isChoose) {
                              choose.remove(sports[index]);
                            } else {
                              choose.add(sports[index]);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color:
                              isChoose ? Colors.black : Color(0xFFE2E2E2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              sports[index],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color:
                                  isChoose ? Colors.white : Colors.black),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
            CustomText(
              text: '影视',
              margin: EdgeInsets.only(top: 8, left: 16, bottom: 16),
            ),
            Container(
              margin: EdgeInsets.only(left: 11, right: 11),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movies.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isChoose = choose.contains(movies[index]);
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (isChoose) {
                              choose.remove(movies[index]);
                            } else {
                              choose.add(movies[index]);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color:
                              isChoose ? Colors.black : Color(0xFFE2E2E2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              movies[index],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color:
                                  isChoose ? Colors.white : Colors.black),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
            CustomText(
              text: '美食',
              margin: EdgeInsets.only(top: 8, left: 16, bottom: 16),
            ),
            Container(
              margin: EdgeInsets.only(left: 11, right: 11),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foods.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isChoose = choose.contains(foods[index]);
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (isChoose) {
                              choose.remove(foods[index]);
                            } else {
                              choose.add(foods[index]);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color:
                              isChoose ? Colors.black : Color(0xFFE2E2E2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              foods[index],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color:
                                  isChoose ? Colors.white : Colors.black),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
            CustomText(
              text: '艺术',
              margin: EdgeInsets.only(top: 8, left: 16, bottom: 16),
            ),
            Container(
              margin: EdgeInsets.only(left: 11, right: 11),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.4,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: arts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isChoose = choose.contains(arts[index]);
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (isChoose) {
                              choose.remove(arts[index]);
                            } else {
                              choose.add(arts[index]);
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: new BoxDecoration(
                              color:
                              isChoose ? Colors.black : Color(0xFFE2E2E2),
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                            ),
                            alignment: Alignment.center,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              arts[index],
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color:
                                  isChoose ? Colors.white : Colors.black),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
