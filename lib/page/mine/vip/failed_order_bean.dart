
class FailedOrderBean{
  int orderid;  String receiptData;
  String transactionID;
  FailedOrderBean(this.orderid,this.transactionID,this.receiptData);

  @override
  String toString() {
    return 'FailedOrderBean{orderid: $orderid, receiptData: $receiptData, transactionID: $transactionID}';
  }
  Map<String, dynamic> toJson() => {
    'orderid': orderid,
    'receiptData': receiptData,
    'transactionID': transactionID,
  };
}