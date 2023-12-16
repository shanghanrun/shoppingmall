import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final NumberFormat numberFormat = NumberFormat('###,###,###,###');

late final SharedPreferences sharedP;
void initializeSharedPreferences() async {
  sharedP = await SharedPreferences.getInstance();
}
