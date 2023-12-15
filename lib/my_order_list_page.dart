import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'item_order_result_page.dart';
import 'models/product.dart';
import 'package:kpostal/kpostal.dart';
import '../components/basic_dialog.dart';

class MyOrderListPage extends StatefulWidget {
  const MyOrderListPage({super.key});

  @override
  State<MyOrderListPage> createState() => _MyOrderListPageState();
}

class _MyOrderListPageState extends State<MyOrderListPage> {
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

  final formKey = GlobalKey<FormState>(); // * 통합위젯 만들기 위한 것

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

  final depositNameController = TextEditingController(); // *입금자 성명받아오기

  //! 결제수단 옵션 선택 변수
  static const List<String> paymentMethodList = [
    '결제수단선택',
    '카드결제',
    '무통장입금',
  ];
  var selectedPaymentMethod = paymentMethodList.first; // * index번호로 정할 수도 있다.

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
            //! 입력폼 필드
            Form(
              key: formKey,
              child: Column(
                children: [
                  //! 입력폼 필드
                  inputTextField(
                    controller: buyerNameController,
                    hintText: "주문자명",
                  ),
                  inputTextField(
                      controller: buyerEamilController, hintText: "주문자 이메일"),
                  inputTextField(
                      controller: buyerPhoneController, hintText: "주문자 핸드폰번호"),
                  inputTextField(
                      controller: receiverNameController, hintText: "받는사람 이름"),
                  inputTextField(
                      controller: receiverPhoneController,
                      hintText: "받는사람 핸드폰번호"),

                  receiverZipTextField(), //! 기존 것 그대로 사용한다.
                  inputTextField(
                      controller: receiverAddress1Controller,
                      hintText: "받는사람 기본주소",
                      readOnly: true),
                  inputTextField(
                      controller: receiverAddress2Controller,
                      hintText: "받는사람 상세주소"),
                  inputTextField(
                    controller: userPwdController,
                    hintText: "비회원 주문조회 비밀번호",
                    obscureText: true,
                  ),
                  inputTextField(
                      controller: userConfirmPwdController,
                      hintText: "비회원 주문조회 비밀번호 확인",
                      obscureText: true),
                  paymentSelectDropdownButton(), //! dropdown 버튼
                  if (selectedPaymentMethod == '카드결제') //여기서는 중괄호 못쓴다.
                    // 앞에서 paymentSelectDropdownButton을 실행했으니,selectedPaymentMethod 인식된다.
                    Column(
                      children: [
                        inputTextField(
                            controller: cardNoController, hintText: "카드번호"),
                        inputTextField(
                            controller: cardAuthController,
                            hintText: "카드명의자 주민번호앞자리 또는 사업자번호",
                            maxLength: 10),
                        inputTextField(
                            controller: cardExpiredDateController,
                            hintText: "카드 만료일(YYYYMM)",
                            maxLength: 6),
                        inputTextField(
                            controller: cardPwdTwoDigitsController,
                            hintText: "카드 비밀번호 앞2자리",
                            maxLength: 2),
                      ],
                    ),
                  if (selectedPaymentMethod == '무통장입금')
                    inputTextField(
                        controller: depositNameController, hintText: "입금자명"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          child: Text('총 ${numberFormat.format(totalPrice)}원 결제하기'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if (selectedPaymentMethod == '결제수단선택') {
                showDialog(
                  context: context,
                  barrierDismissible: true, //다이얼로그 창 밖으로 못 나가게 방지
                  builder: (context) {
                    return BasicDialog(
                      content: "결제수단을 선택해 주세요.",
                      buttonText: '닫기',
                      buttonFunction: () => Navigator.of(context).pop(),
                    );
                  },
                );
              }
              // '기타 결제 수단'인 경우
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ItemOrderResultPage(
                    paymentMethod: selectedPaymentMethod,
                    paymentAmount: totalPrice,
                    receiverName: receiverNameController.text,
                    receiverPhone: receiverPhoneController.text,
                    zip: receiverZipController.text,
                    address1: receiverAddress1Controller.text,
                    address2: receiverAddress2Controller.text,
                  );
                },
              ));
            }
          },
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

  Widget inputTextField({
    //! 아래 함수들 통합 함수 //
    required TextEditingController controller,
    required String hintText,
    int? maxLength, // * 비밀번호 및 사업자번호 (?는 널값 허용)
    bool obscureText = false, // 옵션인데 초기값을 넣어주면 ? 필요없다. 값이 있으니,
    bool readOnly = false, // obscure,readOnly 값은 인자로 안 넣을 수도 있다는 것
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "내용을 입력해 주세요."; //이때 return은 알아서 칸에 출력된다.
          } else {
            if (controller == userConfirmPwdController &&
                userPwdController.text != userConfirmPwdController.text) {
              return "비밀번호가 일치하지 않습니다.";
            }
          }
          return null; //* 아무이상없을 때 null리턴. 만약 null리턴안하면 validator못 빠져나옴
        },
        maxLines: 1, // 추가
        maxLength: maxLength,
        obscureText: obscureText,
        readOnly: readOnly,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget receiverZipTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: receiverZipController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "우편번호"),
            ),
          ),
          const SizedBox(width: 15),
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return KpostalView(callback: (Kpostal result) {
                      receiverZipController.text = result.postCode;
                      receiverAddress1Controller.text = result.address;
                    });
                  },
                ),
              );
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Text('우편번호 찾기'),
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentSelectDropdownButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5), // 디폴트 1.0이다.
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value ?? "";
          });
        },
        underline: Container(),
        isExpanded: true,
        items: paymentMethodList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
