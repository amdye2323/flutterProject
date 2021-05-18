import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_select/smart_select.dart';
import 'package:testflutter/DTO/User.dart';

import '../DTO/skuInfo.dart';

class stockService {
  final String baseUrl = "http://172.30.1.1:8080";
  final Map<String, String> header = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Future<skuInfo> requestSkuInfo(String barcode) async {
    String url = "http://172.30.1.1:8080/api/hello?barcode=${barcode}";

    var response = await http.get(url, headers: header);

    String responsBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responsBody);

    if (json["result"] == "nothing") {
      return Future.error("error");
    }
    // skuInfo _sku = skuInfo(sku:json["sku"],corCode: json["corCode"],skuLabel: json["skuLabel"]);

    return skuInfo(
        sku: json["sku"], corCode: json["corCode"], skuLabel: json["skuLabel"]);
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
      return null;
    } else if (json["result"] == "passNot") {
      return null;
    } else if (json["result"] == "success") {
      return User(id: json["id"], name: json["name"]);
    }
    return null;
    // print("Name : ${data.name} , Password : ${data.password} ");
    // if(!users.containsKey(data.name)){
    //     return 'Username not exits';
    // }
    // if(users[data.name] != data.password){
    //     return 'Password does not match';
    // }
    // return null;
  }

  Future<List<S2Choice<String>>> getCorCode() async {
    String url = "${baseUrl}/api/corCode";
    var response = await http.get(url, headers: header);

    String resonseBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(resonseBody);
    List<S2Choice<String>> options = [
      S2Choice<String>(value: "1", title: "1차"),
      S2Choice<String>(value: "2", title: "2차"),
      S2Choice<String>(value: "3", title: "3차"),
      S2Choice<String>(value: "4", title: "4차"),
      S2Choice<String>(value: "5", title: "5차"),
    ];
    if (json["result"] == "error") {
      return null;
    } else if (json["result"] == "success") {
      var reList = json["list"] as Map<String, String>;
      // reList.forEach((key, value) {
      //   options.add(S2Choice(value: value, title: key));
      // });
      return options;
    }
    return options;
  }
}
