

import 'package:emersit/Utils.dart';
import 'package:emersit/filledform/FilledFormsPage.dart';
import 'package:emersit/main/SubmittedFormsPage.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatelessWidget{

    static const String HOME_KEY = 'Home';
    static const String FILLED_FORMS_KEY = 'Filled Forms';
    static const String EXIT_KEY = 'Exit';

    User user;
    BuildContext context;

    DrawerNavigation(this.user,this.context);


  @override
  Widget build(BuildContext context) {

    return Drawer(
        child: ListView(
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
                                user.name,
                                style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400
                                ),
                            ),
                        ],
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                    ),
                ),
                ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        HOME_KEY,
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
                                        FILLED_FORMS_KEY,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubmittedFormsPage(user)));
                    },
                ),
                SizedBox(height: 200,),
                ListTile(
                    title: Container(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                            child: Text(
                                EXIT_KEY,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                ),
                            )
                    ),
                    onTap: () {
                        Utils.logOut(context, user.token);
                    },
                ),
            ],
        ),
    );
  }
}