
import 'dart:convert';

import 'package:emersit/Network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/Login.dart';


class Utils {

    static const MAIN_COLOR = Color(0xffff2020);

    static const String APP_NAME = 'Emersit';

    static const String QUESTION_TYPE_TEXT = 'Text';
    static const String QUESTION_TYPE_NUMBER = 'Number';
    static const String QUESTION_TYPE_DATE = 'Date';
    static const String QUESTION_TYPE_LOCATION = 'Location';

    static const String GOOGLE_API_KEY = "AIzaSyBcUG-fn8sQSJplBXOTqoHoEhnwM7pg_yM";

    static Future<void> logOut(BuildContext context, String token) async {

        Network.logout(token).then( (response) async {
            var jsonResponse = json.decode(response.body);

            print(jsonResponse);

            if(jsonResponse['status'] != null && jsonResponse['status'] == 200){

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', null);
                await prefs.setString('user', null);

                while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                );

            }
        });
    }

    static String getSituationTypeIconAsset(String type){
        switch(type){
            case "earthquake" :{
                return "assets/images/earthquake.png";
            }
            case "fire" :{
                return "assets/images/fire.png";
            }
            case "flood" :{
                return "assets/images/flood.png";
            }
            case "storm" :{
                return "assets/images/storm.png";
            }
            case "tornado" :{
                return "assets/images/tornado.png";
            }
        }
    }


}