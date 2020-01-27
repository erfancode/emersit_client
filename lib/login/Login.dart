
import 'dart:convert';

import 'package:emersit/main/MainPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class LoginPage extends StatefulWidget{
    LoginPage({Key key}) : super(key: key);

    @override
    State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    String username;
    String password;

    bool canLogin = false;

    bool isLoading = false;

//    static BaseOptions options = new BaseOptions(
//        baseUrl: "https://emersit.herokuapp.com/api",
//        connectTimeout: 60000,
//        receiveTimeout: 60000,
//    );
//    Dio dio = new Dio(options);

    @override
    Widget build(BuildContext context) {

        final usernameField = TextField(
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
            ),
            decoration: InputDecoration(
                labelText: 'Username',
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(24.0)),
            ),
            onChanged: (text) {
                username = text;
                checkUsernamePassword();
            },
        );

        final passwordField = TextField(
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
            ),
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(24.0)),
            ),
            onChanged: (text) {
                password = text;
                checkUsernamePassword();
            },
        );

        final loginButton = RaisedButton(
            onPressed: isLoading ? null : _login,
            color: Color(0xffff2020),
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
            ),
            child: isLoading ? SizedBox(
                child : CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffff2020)),
                ),
                height: 24,
                width: 24,
            ) : Text(
                "Log In",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                ),
            ),
        );

        return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            body: Stack(
                children: <Widget>[
                    //todo add back icon
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child : SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        SizedBox(height: 40),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffff2020),
                                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                            ),

                                            child: Image.asset(
                                                "assets/images/logo.png",
                                                height: 72.0,
                                                width: 72.0,
                                            ),
                                        ),
                                        Text(
                                            "Emersit",
                                            style: TextStyle(
                                                fontSize: 34.0,
                                                color: Color(0xffff2020),
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        Text(
                                            "Emergency Situation",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xff9e9e9e),
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w300
                                            ),
                                        ),
                                        SizedBox(height: 26.1),
                                        Text(
                                            "Welcome!",
                                            style: TextStyle(
                                                fontSize: 27.0,
                                                color: Color(0xff000000),
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400
                                            ),
                                        ),
                                        Text(
                                            "Login to continue",
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                color: Color(0xff000000),
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w300
                                            ),
                                        ),
                                        SizedBox(height: 26.2),
                                        usernameField,
                                        SizedBox(height: 24.0),
                                        passwordField,
                                        SizedBox(height: 24.0),
                                        SizedBox(
                                            height: 48.0,
                                            width: double.infinity,
                                            child: loginButton,
                                        ),
                                        SizedBox(
                                            height: 15.0,
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> _login() async {
        if(canLogin) {

            setState(() {
              isLoading = true;
            });
            var response = await http.post("https://emersit.herokuapp.com/api/user/login", body: {"password": password, "username": username});
            print('Response body: ${response.body}');

            var jsonResponse = json.decode(response.body);

            if(jsonResponse["user"] != null) {

                User user = User.fromJson(jsonResponse["user"]);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', user.token);
                await prefs.setString('user', json.encode(user.toJson()));

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(user)),);
            }
            else{
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text(
                                jsonResponse["description"] != null ? jsonResponse["description"]: "Something went wrong! Try again.",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                        ),

                        duration: Duration(milliseconds: 1500),
                        backgroundColor: Color(0xffff2020),
                ));
            }
            setState(() {
                isLoading = false;
            });
        }
    }

    void checkUsernamePassword(){

        if(username.length > 0 && password.length > 0){
            canLogin = true;
        }
        else{
            canLogin = false;
        }
    }
}