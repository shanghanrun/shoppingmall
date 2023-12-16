import 'package:flutter/material.dart';
import 'package:shoppingmall/item_basket_page.dart';
import 'package:shoppingmall/item_details_page.dart';
import 'package:shoppingmall/my_order_list_page.dart';
import 'models/product.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_list.dart' as pl;

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');
  List<Product> productList = pl.productList; // 서로 다른 이름을 사용해야 된다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('제품 리스트'),
          centerTitle: true,
          actions: [
            IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const MyOrderListPage();
                  }));
                }),
            IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const ItemBasketPage();
                  }));
                }),
          ],
        ),
        body: GridView.builder(
            itemCount: productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8), //세로10 가로 8
            itemBuilder: (context, i) {
              return productContainer(
                productNo: productList[i].productNo ?? 0,
                productName: productList[i].productName ?? "",
                //요소가 Product클래스라서 .productName 가능하다.
                //그런데, 널문제로 productList[i].productName! 할 수도 있지만
                //그러면, 반드시 있어야 될 값이 되는데, 만약 값이 안들어오면 런타임에러가 발생된다.
                productImageUrl: productList[i].productImageUrl ?? "",
                price: productList[i].price ?? 0,
                //String에 대해서는 ""로 하고, 숫자는 0
              );
            }));
  }

  Widget productContainer(
      {required int productNo,
      required String productName,
      required String productImageUrl,
      required double price}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemDetailsPage(
              productNo: productNo,
              productName: productName,
              productImageUrl: productImageUrl,
              price: price);
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          Expanded(
            child: CachedNetworkImage(
                height: 150,
                fit: BoxFit.cover,
                imageUrl: productImageUrl,
                placeholder: (context, url) {
                  //이미지 로딩중 보여줄 것
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ));
                },
                errorWidget: (context, url, error) {
                  return const Center(child: Text('오류발생'));
                }),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(productName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
              padding: const EdgeInsets.all(8),
              child: Text('${numberFormat.format(price)}원'))
        ]),
      ),
    );
  }
}
