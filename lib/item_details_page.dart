import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'item_basket_page.dart';

class ItemDetailsPage extends StatefulWidget {
  final int productNo;
  final String productName;
  final String productImageUrl;
  final double price;

  const ItemDetailsPage({
    super.key,
    required this.productNo,
    required this.productName,
    required this.productImageUrl,
    required this.price,
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 상세 페이지'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover, // 이미지가 크게 나온다.
                  imageUrl: widget.productImageUrl, //stf클래스와 state클래스는 다르다.
                  // 그래서 stf클래스의 변수값을 가져오려면, widget을 붙여야 된다.
                  placeholder: (context, url) {
                    return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorWidget: (context, url, error) {
                    return const Center(child: Text('오류발생'));
                  }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(widget.productName,
                  textScaleFactor: 1.5, // 폰트사이지 몇배
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '${numberFormat.format(widget.price)}원', // 숫자라서 문자''로 바꾸어야 된다.
                textScaleFactor: 1.3, // 폰트사이지 몇배
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        // 장바구니에 담는 기능
        padding: const EdgeInsets.all(20),
        child: FilledButton(
            // Material3 디자인에 있는 버튼
            child: const Text('장바구니 담기'),
            onPressed: () {
              /// 추후 장바구니 담는 로직 추가
              ///
              /// 장바구니 페이지로 이동
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ItemBasketPage();
                },
              ));
            }),
      ),
    );
  }
}
