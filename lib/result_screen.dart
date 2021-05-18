import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testflutter/document_view.dart';

class ResultScreen extends StatefulWidget {

  final String index;
  //매개변수를 index 저장해줌
  ResultScreen(this.index);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Firestore firestore = Firestore.instance;//파이어베이스 인스턴스 생성
  Stream<QuerySnapshot> currentStream;//스트림 생성
  List<String> menuIndex = ["see all","already purchased","price<20000"];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch(widget.index){
      case "all" : {
        currentStream = firestore.collection("books").snapshots();
        break;
      }
      case "purchase" : {
        currentStream = 
            firestore.collection("books").where("purchase?", isEqualTo: true).snapshots();
        break;
      }
      case "price" : {
        currentStream = firestore.collection("books").where("price" , isLessThan: 20000).snapshots();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BOOK SHELF"),
        actions: <Widget>[
          PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return menuIndex.map((choice) => PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                )
                ).toList();
              },
              onSelected: (String choice){
                if(choice == "see all") Navigator.pushNamed(context, "/");
                else if(choice == "already purchased")
                  Navigator.pushNamed(context, 'a');
                else Navigator.pushNamed(context, 'b');
              },
          )
          ],
      ),
      body: StreamBuilder(
        stream: currentStream,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          List<DocumentSnapshot> documents = snapshot.data.documents;
          return ListView(
            padding: EdgeInsets.only(top: 20.0),
            children: documents.map((eachDocument) => DocumentView(eachDocument)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, 'c');
          },
          label: Text("ADD"),
          icon : Icon(Icons.add)
      ),
    );
  }
}
