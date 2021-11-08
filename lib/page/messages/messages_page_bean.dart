class MsgPageBean {
  String time = '';
  String sessionId = '';
  int unreadMsgNum = 0;
  String heardUrl = '';
  String nickName = '';
  int? age;
  int? height;
  String? region;

  int getUid() {
    return int.parse(sessionId.substring(sessionId.lastIndexOf('l') + 1));
  }

  String getInfo() {
    String ageS = age == null ? '' : '$age岁';
    String heightS = height == null ? '' : '·${height}cm';
    String regionS = region == null ? '' : '·$region';
    return ageS + heightS + regionS;
  }
}
