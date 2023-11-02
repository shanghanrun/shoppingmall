import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/product.dart';

class ItemCheckoutPage extends StatefulWidget {
  const ItemCheckoutPage({super.key});

  @override
  State<ItemCheckoutPage> createState() => _ItemCheckoutPageState();
}

class _ItemCheckoutPageState extends State<ItemCheckoutPage> {
  List<Product> checkoutList = [
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

  //! controller 변수 14개 추가
  final buyerNameController = TextEditingController();
  final buyerEamilController = TextEditingController();
  final buyerPhoneController = TextEditingController();
  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final receiverZipController = TextEditingController();
  final receiverAddress1Controller = TextEditingController();
  final receiverAddress2Controller = TextEditingController();
  final userPwdController = TextEditingController();
  final userConfirmPwdController = TextEditingController();
  final cardNoController = TextEditingController();
  final cardAuthController = TextEditingController();
  final cardExpiredDateController = TextEditingController();
  final cardPwdTwoDigitsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < checkoutList.length; i++) {
      totalPrice +=
          checkoutList[i].price! * quantityList[i][checkoutList[i].productNo]!;
      // 여기서 주의할 점은 quantaityList[i][productNo]가 안된다.
      // productNo는 checkoutList[i]를 통해서 접근이 가능하다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제시작'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), // 추가
        child: Column(
          children: [
            ListView.builder(
              itemCount: checkoutList.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return checkoutContainer(
                  productNo: checkoutList[i].productNo ?? 0,
                  productName: checkoutList[i].productName ?? "",
                  productImageUrl: checkoutList[i].productImageUrl ?? "",
                  price: checkoutList[i].price ?? 0,
                  quantity: quantityList[i][checkoutList[i].productNo] ?? 0,
                );
              },
            ),
            //입력폼 필드
            buyerNameTextField(),
            buyerEmailTextField(),
            buyerPhoneTextField(),
            receiverNameTextField(),
            receiverPhoneTextField(),
            receiverZipTextField(),
            receiverAddress1TextField(),
            receiverAddress2TextField(),
            userPwdTextField(),
            userConfirmPwdTextField(),
            cardNoTextField(),
            cardAuthTextField(),
            cardExpiredDateTextField(),
            cardPwdTwoDigitsTextField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget checkoutContainer({
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
                  Text('수량: $quantity'),
                  Text('합계: ${numberFormat.format(price * quantity)}원'),
                ]),
          ),
        ],
      ),
    );
  }

  Widget buyerNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: buyerNameController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "주문자명"),
      ),
    );
  }

  Widget buyerEmailTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: buyerEamilController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "주문자 이메일"),
      ),
    );
  }

  Widget buyerPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: buyerPhoneController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "주문자 휴대전화"),
      ),
    );
  }

  Widget receiverNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: receiverNameController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "받는 사람 이름"),
      ),
    );
  }

  Widget receiverPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: receiverPhoneController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "받는 사람 휴대전화"),
      ),
    );
  }

  Widget receiverZipTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: receiverZipController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "우편번호"),
      ),
    );
  }

  Widget receiverAddress1TextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: receiverAddress1Controller,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "기본 주소"),
      ),
    );
  }

  Widget receiverAddress2TextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: receiverAddress2Controller,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "상세 주소"),
      ),
    );
  }

  Widget userPwdTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: userPwdController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "비회원 주문조회 비밀번호"),
      ),
    );
  }

  Widget userConfirmPwdTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: userConfirmPwdController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "비회원 주문조회 비밀번호 확인"),
      ),
    );
  }

  Widget cardNoTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: cardNoController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "카드번호"),
      ),
    );
  }

  Widget cardAuthTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: cardAuthController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "카드명의자 주민번호 앞자리"),
      ),
    );
  }

  Widget cardExpiredDateTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: cardExpiredDateController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "카드 만료일"),
      ),
    );
  }

  Widget cardPwdTwoDigitsTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: cardPwdTwoDigitsController,
        maxLines: 1, // 추가
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: "카드 비밀번호 앞2자리"),
      ),
    );
  }
}
