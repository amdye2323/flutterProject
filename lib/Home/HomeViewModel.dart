import 'package:testflutter/DTO/BarcodeZone.dart';
import 'package:testflutter/DTO/PickingList.dart';
import 'package:testflutter/DTO/User.dart';
import 'package:testflutter/DTO/barcodeCheckList.dart';
import 'package:testflutter/DTO/skuZoneList.dart';

import '../DTO/skuInfo.dart';
import '../service/stockService.dart';

class HomeViewModel {
  final _service = stockService();

  Future<List<skuInfo>> skuDetail(String barcode) async {
    return await _service.requestSkuInfo(barcode);
  }

  Future<User> loginUser(String id, String password) async {
    return await _service.loginUser(id, password);
  }

  Future<List<Map<String, String>>> getCorCode() async {
    return await _service.getCorCode();
  }

  Future<List<PickingList>> getPickList(
      String currentDate, String corCode, String step) async {
    return await _service.getPickList(currentDate, corCode, step);
  }

  Future<List<barcodeCheckList>> getResultCorcodeList(
      List<String> barcodeList, String userId) async {
    return await _service.getResultCorcodeList(barcodeList, userId);
  }

  Future<BarcodeZone> getBarcodeZone(String barcode) async {
    return await _service.getBarcodeZone(barcode);
  }

  Future<String> stockMoveToZone(
      String scanBarcode, String zoneBarcode, String userId) async {
    return await _service.stockMoveToZone(scanBarcode, zoneBarcode, userId);
  }

  Future<String> stockMoveToCompany(
      String scanBarcode, String userId, String qty, String oriQty) async {
    return await _service.stockMoveToCompany(scanBarcode, userId, qty, oriQty);
  }

  Future<String> stockMoveToPickingZone(
      String scanBarcode, String userId, String qty, String oriQty) async {
    return await _service.stockMoveToPickingZone(
        scanBarcode, userId, qty, oriQty);
  }

  Future<String> stockMoveDivision(
      String scanBarcode, String userId, String qty, String oriQty) async {
    return await _service.stockMoveDivision(scanBarcode, userId, qty, oriQty);
  }

  Future<List<skuInfo>> barcodeSkuList(String barcode) async {
    return await _service.barcodeSkuList(barcode);
  }

  Future<List<skuZoneList>> getSkuZoneList(String sku) async {
    return await _service.getSkuZoneList(sku);
  }
}
