import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/constants.dart';
import 'package:shoppingmall/enums/delivery_status.dart';
import 'package:shoppingmall/enums/payment_status.dart';
import 'package:shoppingmall/models/order.dart';
import 'models/product.dart';

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({super.key});

  @override
  State<MyOrderListPage> createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {
  List<Product> productList = [
    Product(
      productNo: 1,
      productName: '노트북(Laptop)',
      productImageUrl: "https://picsum.photos/id/1/300/300",
      price: 600000,
    ),
    Product(
      productNo: 4,
      productName: "키보드(Keyboard)",
      productImageUrl: "https://picsum.photos/id/60/300/300",
      price: 50000,
    ),
  ];

  List<Order> orderList = [
    Order(
      orderId: 1,
      productNo: 1,
      orderDate: "2023-11-24",
      orderNo: "2023114-123456123",
      quantity: 2,
      totalPrice: 1200000,
      paymentStatus: "completed",
      deliveryStatus: "deliverying",
    ),
    Order(
      orderId: 2,
      productNo: 4,
      orderDate: "2023-11-24",
      orderNo: "2023114-123456135",
      quantity: 3,
      totalPrice: 1500000,
      paymentStatus: "waiting",
      deliveryStatus: "waiting",
    ),
  ];

  List<Map<int, int>> quantityList = [
    {1: 2},
    {4: 3}
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('나의 주문목록'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // 추가
          child: Column(
            children: [
              ListView.builder(
                itemCount: orderList.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return orderContainer(
                    productNo: orderList[i].productNo ?? 0,
                    productName: productList[i].productName ?? "",
                    productImageUrl: productList[i].productImageUrl ?? "",
                    price: orderList[i].totalPrice ?? 0,
                    quantity: quantityList[i][orderList[i].productNo] ?? 0,
                    orderDate: orderList[i].orderDate ?? "",
                    orderNo: orderList[i].orderNo ?? "",
                    paymentStatus: orderList[i].paymentStatus ?? "",
                    deliveryStatus: orderList[i].deliveryStatus ?? "",
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
                child: const Text('홈으로'),
                onPressed: () {
                  Navigator.of(context).pop();
                })));
  }

  Widget orderContainer(
      {required int productNo,
      required String productName,
      required String productImageUrl,
      required double price,
      required int quantity,
      required String orderDate,
      required String orderNo,
      required String paymentStatus,
      required String deliveryStatus}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "주문날짜: $orderDate",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: productImageUrl,
                width: MediaQuery.of(context).size.width * 0.41,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Text("오류 발생"),
                  );
                },
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(productName,
                          textScaleFactor: 1.4,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${numberFormat.format(price)}원'),
                      Text('수량: $quantity'),
                      Text('합계: ${numberFormat.format(price * quantity)}원'),
                      Text(
                        "${PaymentStatus.getStatusName(paymentStatus).statusName} / ${DeliveryStatus.getStatusName(deliveryStatus).statusName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton.tonal(
                child: const Text('주문취소'),
                onPressed: () {},
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                child: const Text('배송조회'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
