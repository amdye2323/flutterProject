import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class barcodeInvoiceCheckListView extends StatefulWidget {
  const barcodeInvoiceCheckListView({Key key}) : super(key: key);

  @override
  _barcodeInvoiceCheckListViewState createState() =>
      _barcodeInvoiceCheckListViewState();
}

class _barcodeInvoiceCheckListViewState
    extends State<barcodeInvoiceCheckListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              color: Colors.black,
            ),
            Container(
              alignment: Alignment.topCenter,
              color: Colors.black,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '피킹존리스트',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(CupertinoIcons.return_icon),
            onPressed: () => Navigator.pop(context)));
  }
}

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  border: Border.all(
    color: Color(0xFF527DAA),
  ),
  borderRadius: BorderRadius.circular(10.0),
);
