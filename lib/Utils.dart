
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Utils {


    static Future<bool> logOut(String token) async {

        var getFormsResponse = await http.get("https://emersit.herokuapp.com/api/user/logout", headers: {"token": token},);

        var jsonResponse = json.decode(getFormsResponse.body);

        print(jsonResponse);

        if(jsonResponse['status'] != null && jsonResponse['status'] == 200){

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', null);
            await prefs.setString('user', null);

            return true;
        }
        else{
            return false;
        }

    }

}