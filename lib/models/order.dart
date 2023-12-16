class Order {
  int? orderId;
  int? productNo;
  int? quantity;
  double? totalPrice;
  String? orderNo;
  String? orderDate;
  String? paymentStatus;
  String? deliveryStatus;

  Order(
      {this.orderId,
      this.orderNo,
      this.productNo,
      this.quantity,
      this.totalPrice,
      this.orderDate,
      this.paymentStatus,
      this.deliveryStatus});
  Order.fromJson(Map<String, dynamic> json) {
    orderId = int.parse(json['orderId']);
    productNo = json['productNo'];
    orderDate = json['orderDate'];
    orderNo = json['orderNo'];
    quantity = json['quantity'];
    totalPrice = double.parse(json['totalPrice']);
    paymentStatus = json['paymentStatus'];
    deliveryStatus = json['deliveryStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = orderId;
    data['productNo'] = productNo;
    data['orderDate'] = orderDate;
    data['orderNo'] = orderNo;
    data['quantity'] = quantity;
    data['paymentStatus'] = paymentStatus;
    data['deliveryStatus'] = deliveryStatus;
    return data;
  }
}
