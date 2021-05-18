import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/User.dart';

import '../DTO/skuInfo.dart';
import '../service/stockService.dart';

class HomeViewModel {
  final _service = stockService();

  // Future<skuInfo> skuDetail(String barcode) async {
  //   return Future.delayed(Duration(seconds: 2) , () async{
  //     final myFu = await _service.requestSkuInfo(barcode);
  //     return myFu;
  //   });
  // }
  Future<skuInfo> skuDetail(String barcode) async {
    return await _service.requestSkuInfo(barcode);
  }

  // Future<String> loginUser(LoginData data) async {
  //   return Future.delayed(Duration(seconds: 1), () async {
  //     return await _service.loginUser(data);
  //   });
  // }

  Future<User> loginUser(String id, String password) async {
    return Future.delayed(Duration(seconds: 1), () async {
      return await _service.loginUser(id, password);
    });
  }

  Future<List<S2Choice<String>>> getCorCode() async {
    return await _service.getCorCode();
  }
}
