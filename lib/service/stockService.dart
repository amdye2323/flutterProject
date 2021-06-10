import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testflutter/DTO/BarcodeZone.dart';
import 'package:testflutter/DTO/PickingList.dart';
import 'package:testflutter/DTO/User.dart';
import 'package:testflutter/DTO/barcodeCheckList.dart';
import 'package:testflutter/DTO/barcodeHistoryInfo.dart';
import 'package:testflutter/DTO/barcodeInvoiceInfo.dart';
import 'package:testflutter/DTO/corCode.dart';
import 'package:testflutter/DTO/pickZoneInfo.dart';
import 'package:testflutter/DTO/skuZoneList.dart';

import '../DTO/skuInfo.dart';

class stockService {
  // final String baseUrl = "http://172.30.1.1:8072";
  // final String baseUrl = "http://192.168.0.10:8072";
  final String baseUrl = "https://alpha.golink.co.kr:444";
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  /**
   * 바코드로 입고된 바코드 입력시 정보 호출
   */
  Future<List<skuInfo>> requestSkuInfo(String barcode) async {
    if (barcode == "default") {
      return null;
    }
    String url = "${baseUrl}/api/barcode?barcode=${barcode}";

    if (barcode == "default") {
      return null;
    }

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();

    var list = json.map<skuInfo>((json) => skuInfo.fromJson(json)).toList();

    if (list.length == 0) {
      return Future.error("error");
    }
    return list;
  }

  /**
   * 로그인
   */
  Future<User> loginUser(String id, String password) async {
    String url = "${baseUrl}/api/login?id=${id}&password=${password}";
    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    print(json);
    if (json["result"] == "error") {
      return Future.error("error");
    } else if (json["result"] == "passNot") {
      return Future.error("error");
    } else if (json["result"] == "success") {
      return User(
          id: json["id"], name: json["name"], password: json['password']);
    }
    return null;
  }

  /**
   * 업체 코드
   */
  Future<List<Map<String, String>>> getCorCode() async {
    String url = "${baseUrl}/api/corList";
    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    var jsonList = json["list"].cast<Map<String, dynamic>>();
    var list = jsonList.map<corCode>((json) => corCode.fromJson(json)).toList();
    List<Map<String, String>> options = [];
    if (json["result"] == "success") {
      for (var i = 0; i < list.length; i++) {
        options.add({
          'value': list[i].subcode.toString(),
          'title': list[i].codename.toString()
        });
      }
      return options;
    }
    return null;
  }

  /**
   * 피킹 리스트 호출
   */
  Future<List<PickingList>> getPickList(
      String currentDate, String corCode, String step) async {
    String url =
        "${baseUrl}/api/pickingList?pickingDate=${currentDate}&corCode=${corCode}&step=${step}";
    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    var jsonList = json["list"].cast<Map<String, dynamic>>();

    var list = jsonList
        .map<PickingList>((json) => PickingList.fromJson(json))
        .toList();
    if (json["result"] == "success") {
      return list;
    }
    return null;
  }

  /**
   * 바코드 체크 리스
   */
  Future<List<barcodeCheckList>> getResultCorcodeList(
      List<String> barcodeList, String userId) async {
    String url =
        "${baseUrl}/api/resulCorcodeList?barcodeList=${barcodeList}&userId=${userId}";
    var response = await http.get(url, headers: header);
    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    var jsonList = json["list"].cast<Map<String, dynamic>>();
    var list = jsonList
        .map<barcodeCheckList>((json) => barcodeCheckList.fromJson(json))
        .toList();
    if (json["result"].toString() == "success") {
      return list;
    } else {
      return Future.error("error");
    }
  }

  /**
   * 바코드 존 스캔
   */
  Future<BarcodeZone> getBarcodeZone(String barcode) async {
    if (barcode == "default") {
      return null;
    }
    String url = "${baseUrl}/api/barcodeZone?barcode=${barcode}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    var jsonList = jsonDecode(responsBody)["list"];

    BarcodeZone zone = BarcodeZone();
    zone.storageZone = jsonList["storageZone"];
    zone.statusZone = jsonList["statusZone"];
    zone.storageZoneBarcode = jsonList["storageZoneBarcode"];

    if (json["result"] != "success") {
      return Future.error("error");
    }
    return zone;
  }

  /**
   * 바코드 재고 이동
   */
  Future<String> stockMoveToZone(
      String scanBarcode, String zoneBarcode, String userId) async {
    String url =
        "${baseUrl}/api/stockMoveToZone?scanBarcode=${scanBarcode}&zoneBarcode=${zoneBarcode}&userId=${userId}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);

    if (json["result"].toString() == "success") {
      return json["result"].toString();
    } else {
      return "error";
    }
  }

  /**
   * 거래선 출고
   */
  Future<String> stockMoveToCompany(
      String scanBarcode, String userId, String qty, String oriQty) async {
    if (int.parse(oriQty) - int.parse(qty) < 0) {
      return "error";
    }
    String url =
        "${baseUrl}/api/stockMoveToCompany?scanBarcode=${scanBarcode}&userId=${userId}&qty=${qty}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);

    if (json["result"].toString() == "success") {
      return "success";
    } else {
      return "error";
    }
  }

  /**
   * 피킹존 이동
  */
  Future<String> stockMoveToPickingZone(
      String scanBarcode, String userId, String qty, String oriQty) async {
    if (int.parse(oriQty) - int.parse(qty) < 0) {
      return "error";
    }
    String url =
        "${baseUrl}/api/stockMoveToPickingZone?scanBarcode=${scanBarcode}&userId=${userId}&qty=${qty}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    print(json);
    if (json["result"].toString() == "success") {
      return "success";
    } else {
      return "error";
    }
  }

  /**
   * 분할등록
   */
  Future<String> stockMoveDivision(String scanBarcode, String zoneBarcode,
      String userId, String qty, String oriQty, String sku) async {
    if (int.parse(oriQty) - int.parse(qty) < 0) {
      return "error";
    }
    String url =
        "${baseUrl}/api/stockMoveDivision?scanBarcode=${scanBarcode}&zoneBarcode=${zoneBarcode}&userId=${userId}&oriQty=${oriQty}&qty=${qty}&sku=${sku}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    print(json);
    if (json["result"].toString() == "success") {
      return "success";
    } else {
      return "error";
    }
  }

  Future<List<skuInfo>> barcodeSkuList(String barcode) async {
    String url = "${baseUrl}/api/barcodeSkuList?barcode=${barcode}";

    if (barcode == "default") {
      return null;
    }

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();

    var list = json.map<skuInfo>((json) => skuInfo.fromJson(json)).toList();

    if (list.length == 0) {
      return Future.error("error");
    }
    return list;
  }

  Future<List<skuZoneList>> getSkuZoneList(String sku) async {
    String url = "${baseUrl}/api/getSkuZoneList?sku=${sku}";
    if (sku == "") {
      return null;
    }
    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();

    var list =
        json.map<skuZoneList>((json) => skuZoneList.fromJson(json)).toList();

    // if (json["result"] == "nothing") {
    //   return Future.error("error");
    // }
    // if (list.length == 0) {
    //   return Future.error("error");
    // }
    return list;
  }

  Future<List<pickZoneInfo>> getCompanyPickingZoneInquiry(
      String corCode) async {
    if (corCode == "") {
      return null;
    }
    String url =
        "${baseUrl}/api/getCompanyPickingZoneInquiry?corCode=${corCode}";
    var response = await http.get(url, headers: header);
    String responsBody = utf8.decode(response.bodyBytes);

    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();

    var list =
        json.map<pickZoneInfo>((json) => pickZoneInfo.fromJson(json)).toList();

    // if (json["result"] == "nothing") {
    //   return Future.error("error");
    // }
    // if (list.length == 0) {
    //   return Future.error("error");
    // }
    return list;
  }

  Future<String> revertPickZoneMaterial(String barcode, String sku, String qty,
      String oriQty, String userId) async {
    if (int.parse(oriQty) - int.parse(qty) < 0) {
      return "error";
    }
    String url =
        "${baseUrl}/api/revertPickZoneMaterial?barcode=${barcode}&sku=${sku}&qty=${qty}&userId=${userId}";
    var response = await http.get(url, headers: header);
    String responseBody = utf8.decode(response.bodyBytes);

    var json = jsonDecode(responseBody);
    if (json["result"] == "success") {
      return "success";
    } else {
      return null;
    }
  }

  Future<List<barcodeHistoryInfo>> getUserPushedBarcodeList(
      String userId, String searchDate) async {
    if (searchDate == "") {
      return null;
    }
    String url =
        "${baseUrl}/api/getUserPushedBarcodeList?date=${searchDate}&userId=${userId}";
    var response = await http.get(url, headers: header);
    String responsBody = utf8.decode(response.bodyBytes);

    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();

    var list = json
        .map<barcodeHistoryInfo>((json) => barcodeHistoryInfo.fromJson(json))
        .toList();

    if (list.length == 0) {
      return null;
    }
    return list;
  }

  Future<List<barcodeInvoiceInfo>> getUserPushedInvoiceList(
      String userId, String searchDate) async {
    if (searchDate == "") {
      return null;
    }
    String url =
        "${baseUrl}/api/getUserPushedInvoiceList?date=${searchDate}&userId=${userId}";
    var response = await http.get(url, headers: header);
    String responsBody = utf8.decode(response.bodyBytes);

    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();

    var list = json
        .map<barcodeInvoiceInfo>((json) => barcodeInvoiceInfo.fromJson(json))
        .toList();

    if (list.length == 0) {
      return null;
    }
    return list;
  }
}
