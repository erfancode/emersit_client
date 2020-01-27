

import 'package:emersit/Utils.dart';
import 'package:emersit/filledform/FilledFormsPage.dart';
import 'package:emersit/login/Login.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPage.dart';

class DrawerNavigation extends StatelessWidget{

    User user;
    BuildContext context;
    DrawerNavigation(User user, BuildContext context){

        this.user = user;
        this.context = context;
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
                DrawerHeader(
                    child : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            Image.asset(
                                "assets/images/profile_photo.png",
                                height: 100.0,
                                width: 100.0,
                            ),
                            SizedBox(height: 16),
                            Text(
                                'Erfan Gholami',
                                style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400
                                ),
                            ),
                        ],
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xffff2020),
                    ),
                ),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Home",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400,
                                        ),
                                    )
                            ),
                            Image.asset(
                                "assets/images/navigation_item_icon.png",
                                height: 12.0,
                                width: 7.0,
                            ),
                        ],

                    ),
                    onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                ),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Filled Forms",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400,
                                        ),
                                    )
                            ),
                            Image.asset(
                                "assets/images/navigation_item_icon.png",
                                height: 12.0,
                                width: 7.0,
                            ),
                        ],

                    ),
                    onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FilledFormsPage()));
                    },
                ),
                SizedBox(height: 200,),
                ListTile(
                    title: Container(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                            child: Text(
                                "Exit",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xffff2020),
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                ),
                            )
                    ),
                    onTap: () {
                        _logout();
                    },
                ),
            ],
        ),
    );
  }

  Future<void> _logout() async {

      Utils.logOut(user.token).then((newValue) {
         if(newValue){
             while(Navigator.canPop(context)){
                 Navigator.pop(context);
             }
             Navigator.push(context,  MaterialPageRoute(builder: (context) => LoginPage()),);
         }
         else{

         }
      });
  }

}