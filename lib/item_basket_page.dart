import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/constants.dart';
import 'package:shoppingmall/item_checkout_page.dart';
import 'models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemBasketPage extends StatefulWidget {
  const ItemBasketPage({super.key});

  @override
  State<ItemBasketPage> createState() => _ItemBasketPageState();
}

class _ItemBasketPageState extends State<ItemBasketPage> {
  final db = FirebaseFirestore.instance;
  late Query<Product>? productsQueryRef; // Query결과에 대한 참조
  // collection 이름을 'products'로 만들어 놨기 때문에
  //late productsCollection productsCollectionRef;  컬렉션에 대한 참조
  // productCollectionRef = db.collection('products') 식으로

  double totalPrice = 0; // 초기화를 안하면 에러
  Map<String, dynamic> cartMap = {};
  Stream<QuerySnapshot<Product>>? productList; // Stream은 List형태이다.
  List<int> keyList = [];

  @override
  void initState() {
    super.initState();
    try {
      //! 저장한 장바구니 리스트 가져오기
      cartMap = json.decode(sharedP.getString('cartMap') ?? "{}") ?? {};
    } catch (e) {
      debugPrint(e.toString());
    }
    //! 조건문에 넘길 product no 키 값 리스트를 integer로 변경
    // firebase에서넘어온 cartMap은 Map<String, dynamic> 형태. 이것에서 key값이 String을 int로 변환
    cartMap.forEach((key, value) {
      keyList.add(int.parse(key));
    });

    //! 파이어스토어에서 데이터 가져오는 Ref변수
    if (keyList.isNotEmpty) {
      productsQueryRef = db
          .collection('products')
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  Product.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson())
          .where('productNo', whereIn: keyList);
      // keyList에 있는 productNo가 있는 데이터만 가져온다.
      //즉, 모든 것들을 가져오는 것이 아니라, cartMap의 key값 리스트에 있는 것들만 가져온다는 것
    }

    productList = productsQueryRef?.orderBy('productNo').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니 페이지'),
        centerTitle: true,
      ),
      body: cartMap.isEmpty
          ? Container()
          : StreamBuilder(
              stream: productList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                      children: snapshot.data!.docs.map((doc) {
                    if (cartMap[doc.data().productNo.toString()] != null) {
                      return basketContainer(
                          productNo: doc.data().productNo ?? 0,
                          productName: doc.data().productName ?? '',
                          productImageUrl: doc.data().productImageUrl ?? '',
                          price: doc.data().price ?? 0,
                          quantity: cartMap[doc.data().productNo.toString()]);
                    } else {
                      return Container();
                    }
                  }).toList());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('오류가 발생했습니다.'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
      bottomNavigationBar: cartMap.isEmpty
          ? const Center(
              child: Text('장바구니에 담긴 제품이 없습니다.'),
            )
          : StreamBuilder(
              stream: productList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  totalPrice = 0;
                  snapshot.data?.docs.forEach((doc) {
                    if (cartMap[doc.data().productNo.toString()] != null) {
                      totalPrice += cartMap[doc.data().productNo.toString()] *
                              doc.data().price ??
                          0;
                    }
                  });
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: FilledButton(
                      child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
                      onPressed: () {
                        // 결제시작 페이지로 이동
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const ItemCheckoutPage();
                        }));
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('오류가 발생했습니다.'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
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
          const SizedBox(width: 10),
          CachedNetworkImage(
            imageUrl: productImageUrl,
            width: MediaQuery.of(context).size.width * 0.32,
            height: 130,
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
                          icon: const Icon(Icons.remove, color: Colors.blue),
                          onPressed: () {
                            //! 수량줄이기(1 초과시에만 감소시킬 수 있음)
                            if (cartMap[productNo.toString()] > 1) {
                              setState(() {
                                cartMap[productNo.toString()]--;
                                //! 변화된 cartMap을 디스크에 반영
                                sharedP.setString(
                                    'cartMap', json.encode(cartMap));
                              });
                            }
                          }),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            //! 실전에서는 재고사항도 고려해야 된다. 무조건 증가만 못한다...여기서는 생략
                            cartMap[productNo.toString()]++;
                            sharedP.setString('cartMap', json.encode(cartMap));
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            //! 장바구니에서 해당 제품 제거
                            cartMap.remove(productNo.toString());
                            sharedP.setString('cartMap', json.encode(cartMap));
                          });
                        },
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
