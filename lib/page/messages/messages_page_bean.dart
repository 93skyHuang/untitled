class MsgPageBean {
  String time = '';
  int unreadMsgNum = 0;
  String heardUrl = '';
  String nickName = '';
  int? age;
  int uid=-1;
  int? height;
  String? region;

  String getInfo() {
    String ageS = age == null ? '' : '$age 岁';
    String heightS = height == null ? '' : '·$height cm';
    String regionS = region == null ? '' : '·$region';
    return ageS + heightS + regionS;
  }
}
