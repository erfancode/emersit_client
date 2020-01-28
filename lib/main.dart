import 'dart:convert';

import 'package:emersit/Network.dart';
import 'package:emersit/Utils.dart';
import 'package:emersit/login/Login.dart';
import 'package:emersit/main/MainPage.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

    @override
    State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

    bool isLogin;
    String userString;

    @override
    void initState() {
        super.initState();

        (() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String token = prefs.getString(Network.TOKEN_KEY);
            String user = prefs.getString(Network.USER_KEY);

            setState(() {
                if(token != null && token.length > 0){
                    userString = user;
                    isLogin = true;
                }
                else{
                    isLogin = false;
                }
            });
        })();
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: Utils.APP_NAME,
            theme: ThemeData(
                primaryColor: Utils.MAIN_COLOR,
            ),
            home: isLogin == null ? SizedBox(
                child : CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Utils.MAIN_COLOR),
                ),
                height: 32,
                width: 32,
            ):(isLogin ? MainPage(User.fromJson(json.decode(userString))) : LoginPage()),
        );
    }

    Future<bool> checkLogin() async {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString(Network.TOKEN_KEY);

        setState(() {
            if(token != null && token.length > 0){
                isLogin = true;
            }
            else{
                isLogin = false;
            }
        });

    }

}
