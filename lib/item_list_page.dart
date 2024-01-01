import 'package:flutter/material.dart';
import 'package:shoppingmall/constants.dart';
import 'package:shoppingmall/item_basket_page.dart';
import 'package:shoppingmall/item_details_page.dart';
import 'package:shoppingmall/my_order_list_page.dart';
import 'models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'product_list.dart' as pl;
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  // List<Product> productList = pl.productList; // 서로 다른 이름을 사용해야 된다.
  final productListRef = FirebaseFirestore.instance
      .collection('products')
      .withConverter(
          fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson());
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
        body: StreamBuilder(
            stream: productListRef.orderBy('productNo').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  children: snapshot.data!.docs
                      .map((doc) => productContainer(
                            productNo: doc.data().productNo ?? 0,
                            productName: doc.data().productName ?? "",
                            productImageUrl: doc.data().productImageUrl ?? "",
                            price: doc.data().price ?? 0,
                          ))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('오류가 발생했습니다.'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
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
