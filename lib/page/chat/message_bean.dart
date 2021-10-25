class MessageBean {
  bool isReceive = false;//是否为接收的消息
  String content = "";
  int type = 0; //0 文字 1语音
  int messageStatus = 0; // 0、正常状态  1、发送中 2、 发送失败
}
