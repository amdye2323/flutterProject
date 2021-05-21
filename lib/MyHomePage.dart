// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';//asnyc / await 지원
// import 'dart:convert';//JSON 데이터 처리 지원
// import 'package:flutter/foundation.dart';//compute 함수를 제공
// import 'package:http/http.dart' as http;
// import 'package:testflutter/DTO/skuInfo.dart';
// import 'package:testflutter/Home/HomeViewModel.dart';
//
// import 'DTO/Photo.dart'; //http 프로토콜 지원
// import 'DTO/skuInfo.dart';
//
// class MyHome extends StatelessWidget{
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     final appTitle = "Isolate demo";
//     return MaterialApp(
//       title: appTitle,
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final _viewModel = HomeViewModel();
//
//   Widget _todayQuestionView(skuInfo skuInfo) {
//     return Padding(
//         padding: EdgeInsets.all(10),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(skuInfo.sku),
//               Text(skuInfo.corCode),
//               Text(skuInfo.skuLabel),
//             ],
//           ),
//         )
//     );
//   }
//
//   Widget _errorView(String errorMessage) {
//     return Padding(
//         padding: EdgeInsets.all(10),
//         child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(errorMessage),
//               ],
//             )
//         )
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CupertinoNavigationBar(
//         middle: Text("onono"),
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.white60,
//       body: FutureBuilder<skuInfo>(
//         future: _viewModel.skuDetail("102A0014"),
//         builder: (context,snapshot){
//           if(snapshot.hasData){
//             return _todayQuestionView(snapshot.data);
//           }else{
//             return Center(
//               child: CupertinoActivityIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
