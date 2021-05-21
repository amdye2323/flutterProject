import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/PickingList.dart';
import 'package:testflutter/DTO/User.dart';
import 'package:testflutter/DTO/corCode.dart';

import '../DTO/skuInfo.dart';

class stockService {
  final String baseUrl = "http://172.30.1.1:8080";
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Future<List<skuInfo>> requestSkuInfo(String barcode) async {
    String url = "${baseUrl}/api/barcode?barcode=${barcode}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody)["list"].cast<Map<String, dynamic>>();
    // var jsonList = json;

    var list = json.map<skuInfo>((json) => skuInfo.fromJson(json)).toList();

    if (list.length == 0) {
      return Future.error("error");
    }
    return list;
  }

  Future<User> loginUser(String id, String password) async {
    const users = const {
      'test123@naver.com': 'test123',
      'sub123@google.com': 'sub123',
    };

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
      return User(id: json["id"], name: json["name"]);
    }
    return null;
  }

  Future<List<S2Choice<String>>> getCorCode() async {
    String url = "${baseUrl}/api/corList";
    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    var jsonList = json["list"].cast<Map<String, dynamic>>();
    var list = jsonList.map<corCode>((json) => corCode.fromJson(json)).toList();
    List<S2Choice<String>> options = [];
    if (json["result"] == "success") {
      for (var i = 0; i < list.length; i++) {
        options.add(S2Choice(
            value: list[i].subcode.toString(),
            title: list[i].codename.toString()));
      }
      return options;
    }
    return null;
  }

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

  Future<List<String>> getResultCorcodeList(
      List<String> barcodeList, String userId) async {
    print(barcodeList);
    String url =
        "${baseUrl}/api/resulCorcodeList?barcodeList=${barcodeList}&userId=${userId}";
    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);
    var list = json["list"].cast<List<String>>();

    if (json["result"] == "success") {
      return list;
    } else {
      return Future.error("error");
    }
  }
}
