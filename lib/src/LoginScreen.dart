import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/Home/HomeViewModel.dart';

import '../DTO/User.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final _idTextEditController = TextEditingController();
  final _passTextEditController = TextEditingController();
  final _viewModel = HomeViewModel();
  var _error_message = "";
  String userInfo = "";

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: "login");
    if (userInfo != null) {
      User user = User();
      user.id = userInfo.split(" ")[1];
      user.password = userInfo.split(" ")[3];
      user.name = userInfo.split(" ")[5];
      Provider.of<UserModel>(context, listen: false).setUser(user);
      Navigator.pushNamed(context, 'MainPage');
    }
  }

  @override
  void dispose() {
    _idTextEditController.dispose();
    _passTextEditController.dispose();
    super.dispose();
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '아이디',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _idTextEditController,
            // keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: '아이디를 입력해주세요',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '비밀번호',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passTextEditController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: '비밀번호를 입력해주세요',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (text) => print(text),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  /**
   * 로그인 버튼
   */
  Widget _buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          final result = await _viewModel.loginUser(
              _idTextEditController.text, _passTextEditController.text);
          if (result == null) {
            _error_message = "아이디와 비밀번호를 확인해주세요.";
          } else {
            if (_rememberMe == true) {
              storage.write(
                  key: "login",
                  value: "id " +
                      _idTextEditController.text.toString() +
                      " " +
                      "password " +
                      _passTextEditController.text.toString() +
                      " " +
                      "name " +
                      result.name.toString());
            }
            Provider.of<UserModel>(context, listen: false).setUser(result);
            Navigator.popAndPushNamed(context, 'MainPage');
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.popAndPushNamed(context, 'MainPage');
          },
          // onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              backWallpaper(),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'GOLINK',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(context),
                      Text(
                        "${_error_message}",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      // _buildSignInWithText(),
                      // _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//
// final kHintTextStyle = TextStyle(
//   color: Colors.white54,
//   fontFamily: 'OpenSans',
// );
//
// final kLabelStyle = TextStyle(
//   color: Colors.white,
//   fontWeight: FontWeight.bold,
//   fontFamily: 'OpenSans',
// );
//
// final kBoxDecorationStyle = BoxDecoration(
//   color: Color(0xFF6CA8F1),
//   borderRadius: BorderRadius.circular(10.0),
//   boxShadow: [
//     BoxShadow(
//       color: Colors.black12,
//       blurRadius: 6.0,
//       offset: Offset(0, 2),
//     ),
//   ],
// );
