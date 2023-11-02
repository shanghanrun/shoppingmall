import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppingmall/item_checkout_page.dart';

import 'models/product.dart';

class ItemBasketPage extends StatefulWidget {
  const ItemBasketPage({super.key});

  @override
  State<ItemBasketPage> createState() => _ItemBasketPageState();
}

class _ItemBasketPageState extends State<ItemBasketPage> {
  List<Product> basketList = [
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
  List<Map<int, int>> quantityList = [
    {1: 2},
    {4: 3}
  ];
  double totalPrice = 0; // 초기화를 안하면 에러
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < basketList.length; i++) {
      totalPrice +=
          basketList[i].price! * quantityList[i][basketList[i].productNo]!;
      // 여기서 주의할 점은 quantaityList[i][productNo]가 안된다.
      // productNo는 basketList[i]를 통해서 접근이 가능하다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니 페이지'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: basketList.length,
        itemBuilder: (context, i) {
          return basketContainer(
            productNo: basketList[i].productNo ?? 0,
            productName: basketList[i].productName ?? "",
            productImageUrl: basketList[i].productImageUrl ?? "",
            price: basketList[i].price ?? 0,
            quantity: quantityList[i][basketList[i].productNo] ?? 0,
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
          onPressed: () {
            // 결제시작 페이지로 이동
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const ItemCheckoutPage();
            }));
          },
        ),
      ),
    );
  }

  Widget basketContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(productName,
                      textScaleFactor: 1.4,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${numberFormat.format(price)}원'),
                  Row(
                    children: [
                      const Text('수량'),
                      IconButton(
                          icon: const Icon(Icons.remove), onPressed: () {}),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text('합계: ${numberFormat.format(price * quantity)}원'),
                ]),
          ),
        ],
      ),
    );
  }
}
