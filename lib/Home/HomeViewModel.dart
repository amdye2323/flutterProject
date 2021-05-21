import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/PickingList.dart';
import 'package:testflutter/DTO/User.dart';

import '../DTO/skuInfo.dart';
import '../service/stockService.dart';

class HomeViewModel {
  final _service = stockService();

  Future<List<skuInfo>> skuDetail(String barcode) async {
    return await _service.requestSkuInfo(barcode);
  }

  Future<User> loginUser(String id, String password) async {
    return Future.delayed(Duration(seconds: 1), () async {
      return await _service.loginUser(id, password);
    });
  }

  Future<List<S2Choice<String>>> getCorCode() async {
    return await _service.getCorCode();
  }

  Future<List<PickingList>> getPickList(
      String currentDate, String corCode, String step) async {
    return await _service.getPickList(currentDate, corCode, step);
  }

  Future<List<String>> getResultCorcodeList(
      List<String> barcodeList, String userId) async {
    return await _service.getResultCorcodeList(barcodeList, userId);
  }
}
