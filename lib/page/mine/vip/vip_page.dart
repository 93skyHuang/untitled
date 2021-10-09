import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widget/custom_text.dart';

class VipPage extends StatefulWidget {
  const VipPage();

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  TapGestureRecognizer _registProtocolRecognizer = TapGestureRecognizer();
  TapGestureRecognizer _privacyProtocolRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        leading: new IconButton(
            icon: Icon(Icons.chevron_left, size: 38, color: Colors.black),
            onPressed: () {
              Navigator.maybePop(context);
            }),
        title:
            Text("超级会员", style: TextStyle(fontSize: 17, color: Colors.black)),
        backgroundColor: Color(0xFFF3CD8E),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/vip_bg.png",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg",
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: '这里是昵称',
                        textAlign: Alignment.center,
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      ),
                      Image(
                        image: AssetImage("assets/images/vip_uncharge.png"),
                      ),
                    ],
                  ),
                  Text("尊享10项专属特权，提高交友成功率",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
            CustomText(
              text: '自动续费，可随时取消',
              textStyle: TextStyle(fontSize: 10, color: Color(0xff8C8C8C)),
              margin: EdgeInsets.only(top: 10, left: 16, bottom: 16),
            ),
            CustomText(
              text: '自动续费服务声明：',
              textStyle: TextStyle(fontSize: 10, color: Color(0xff8C8C8C)),
              margin: EdgeInsets.only(left: 16, bottom: 2),
            ),
            CustomText(
              text:
                  '用户确认购买并付款后计入iTunes账户，如果需要取消订阅，请在当前订阅周期到期前24小时以前，手动在iTunes或Apple ID设置管理中关闭自动续费功能，到期前24小时内取消，将会收取订阅费用。苹果iTunes账户对于自动续费项目会在到期前24小时内扣费，扣费成功后订阅周期顺延于下一个计费周期。',
              textStyle: TextStyle(fontSize: 10, color: Color(0xff8C8C8C)),
              margin: EdgeInsets.only(
                left: 16,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 16),
              child: RichText(
                text: TextSpan(
                  text: "开通前请阅读",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: "《会员服务协议》",
                      style: TextStyle(color: Colors.white),
                      recognizer: _registProtocolRecognizer..onTap = () {},
                    ),
                    TextSpan(
                      text: "及",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: "《自动续费协议》",
                      style: TextStyle(color: Colors.white),
                      //点击事件
                      recognizer: _privacyProtocolRecognizer..onTap = () {},
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 8.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 20, bottom: 20),
            ),
            CustomText(
              text: '超级会员特权',
              textStyle: TextStyle(fontSize: 15, color: Color(0xff8C8C8C)),
              margin: EdgeInsets.only(left: 16, bottom: 13),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_icon.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("会员身份标识",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("专属SVIP展示尊贵身份",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_chat.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("无限畅聊",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("解锁所有未读消息，畅所欲言，更多缘分更多机会",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_recommond.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("推荐不受限制",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("推荐给异性展示不再受限",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_foot.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("揭秘来访者",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("谁又来偷偷看我了？",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_like.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("谁喜欢我",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("看看喜欢我的TA",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_eye.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("查看全部专区",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("解锁所有专区，快人一步发现缘分",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_arrow.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("超级曝光",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("让更多人优先滑到你",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_face.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("有趣的灵魂",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("不限相册、视频、心情发布",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_card.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("动态打卡",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("不限回复动态评论",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            ListTile(
              dense: true,
              leading: Image(
                image: AssetImage("assets/images/vip_heart.png"),
              ),
              contentPadding: EdgeInsets.only(left: 16),
              title: Text("缘分搭讪",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
              subtitle: Text("解锁距离我最近的TA",
                  style: TextStyle(fontSize: 12, color: Color(0xff8C8C8C))),
            ),
            Container(
              height: 1.0,
              color: Color(0xff212121),
              margin: EdgeInsets.only(top: 0),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        margin: EdgeInsets.only(left: 16, bottom: 30, top: 30),
                        decoration: new BoxDecoration(
                          color: Color(0xff212121),
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(30.0),bottomLeft: Radius.circular(30.0)),
                        ),
                        child: Text(
                          "30",
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xffF3CD8E),
                          ),
                        ))),
                Expanded(
                    child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 16, bottom: 30, top: 30),
                        decoration: new BoxDecoration(
                          color: Color(0xffF3CD8E),
                          borderRadius: BorderRadius.only(topRight:Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
                        ),
                        child: Text(
                          "立即开通",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }
}
