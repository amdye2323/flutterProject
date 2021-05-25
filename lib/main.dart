import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/DTO/User.dart';
import 'package:testflutter/DTO/pick.dart';
import 'package:testflutter/src/LoginScreen.dart';
import 'package:testflutter/src/MainPage.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel("", ""),
        ),
        ChangeNotifierProvider(
            create: (context) => pickRequirement("", "", "")),
      ],
      child: MaterialApp(
        home: MyApp(),
      ),
    ));

class MyApp extends StatelessWidget {
  // const MyApp({Key key}) : super(key: key);
  String routNumber = "/";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Returnbox",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      initialRoute:
          Provider.of<UserModel>(context, listen: false).userId.toString() == ""
              ? routNumber = '/'
              : routNumber = 'MainPage',
      routes: {
        '/': (context) => LoginScreen(),
        "MainPage": (context) => MainPage(),
      },
    );
  }
}

Future<String> _checkUser(context) async {
  String userId = Provider.of<UserModel>(context, listen: false).userId;
  return await userId;
}

class UserModel extends ChangeNotifier {
  String _id = "";
  String _name = "";

  UserModel(this._id, this._name);

  void setUser(User user) {
    _id = user.id;
    _name = user.name;
    notifyListeners();
  }

  String get userId => _id.toString();

  String get userName => _name.toString();

  void popUser() {
    _id = "";
    _name = "";
    notifyListeners();
  }
}

class pickRequirement extends ChangeNotifier {
  String _pickingDate = "";
  String _corCode = "";
  String _step = "";

  pickRequirement(this._pickingDate, this._corCode, this._step);

  void setPickRequirment(pickVO pick) {
    _pickingDate = pick.pickingDate;
    _corCode = pick.corCode;
    _step = pick.step;
    notifyListeners();
  }

  String get pickingDate => _pickingDate;
  String get corCode => _corCode;
  String get step => _step;

  void resetPick() {
    _pickingDate = "";
    _corCode = "";
    _step = "";
    notifyListeners();
  }
}

Widget backWallpaper() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF73AEF5),
          Color(0xFF61A4F1),
          Color(0xFF478DE0),
          Color(0xFF398AE5),
        ],
        stops: [0.1, 0.4, 0.7, 0.9],
      ),
    ),
  );
}