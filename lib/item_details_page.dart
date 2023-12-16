import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/constants.dart';
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
  int quantity = 1;

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
            productImageContainer(),
            productNameContainer(),
            productPriceContainer(),
            productQuantityContainer(),
            productTotalPriceContainer()
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        //! 장바구니에 담는 기능
        padding: const EdgeInsets.all(20),
        child: FilledButton(
            // Material3 디자인에 있는 버튼
            child: const Text('장바구니 담기'),
            onPressed: () {
              //! 장바구니 담는 로직
              // {"1": 3, "2": 2}    sharedP에는 json형태로 담을 것이다.
              Map<String, dynamic> cartMap =
                  json.decode(sharedP.getString('cartMap') ?? "{}") ?? {};
              if (cartMap[widget.productNo.toString()] == null) {
                cartMap.addAll({widget.productNo.toString(): quantity});
              } else {
                cartMap[widget.productNo.toString()] += quantity;
              }
              sharedP.setString('cartMap', json.encode(cartMap));
              //처음 장바구니를 담을 때는, sharedP에 'cartMap' 없다.
              // 그래서 불러올 때 이름도 없는 빈 {맵}이었지만, 지금 저장하면서 'cartMap'이라는 이름의
              // {'' : } 내용이 들어간 맵으로 String형태로 저장된다.
              print(cartMap);

              //장바구니 페이지로 이동
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const ItemBasketPage();
                },
              ));
            }),
      ),
    );
  }

  Container productPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '${numberFormat.format(widget.price)}원', // 숫자라서 문자''로 바꾸어야 된다.
        textScaleFactor: 1.3, // 폰트사이지 몇배
      ),
    );
  }

  Container productNameContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(widget.productName,
          textScaleFactor: 1.5, // 폰트사이지 몇배
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget productImageContainer() {
    return Container(
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
    );
  }

  Widget productQuantityContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("수량: "),
          IconButton(
            icon: const Icon(Icons.remove, size: 24),
            onPressed: () {
              setState(() {
                if (quantity > 1) {
                  quantity--;
                }
              });
            },
          ),
          Text('$quantity'),
          IconButton(
            icon: const Icon(Icons.add, size: 24),
            onPressed: () {
              setState(() {
                quantity++;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget productTotalPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '총 상품금액',
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${numberFormat.format(widget.price * quantity)}원',
            textScaleFactor: 1.3,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
