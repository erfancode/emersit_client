
import 'dart:convert';

import 'package:emersit/filledform/FilledFormsPage.dart';
import 'package:emersit/main/DrawerNavigation.dart';
import 'package:emersit/main/FormPage.dart';
import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget{

    User user;
    MainPage(this.user, {Key key}) : super(key: key);


    @override
    State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{

//    List widgets = <Widget>[];
    FormList data ;

    bool isLoading = false;

    @override
    void initState() {
        super.initState();

        getFormsFromServer();

//        for (int i = 0; i < 20; i++) {
//            widgets.add(getRow(i));
//        }
    }

    @override
    Widget build(BuildContext context) {

        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: new IconThemeData(color: Color(0xffff2020)),
                backgroundColor: Colors.white,
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        SizedBox(width: 80),
                        Container(
                            decoration: BoxDecoration(
                                color: Color(0xffff2020),
                                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                            ),

                            child: Image.asset(
                                "assets/images/logo.png",
                                height: 31.0,
                                width: 31.0,
                            ),
                        ),
                        Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                "Emersit",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Color(0xffff2020),
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w500,
                                ),
                            ))
                    ],

                ),
            ),
            body: isLoading ? Center(
                    child : SizedBox(
                        child : CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffff2020)),
                        ),
                        height: 32,
                        width: 32,
            )): ListView.builder(
                itemCount: data == null ? 0 : data.forms.length,
                itemBuilder: (BuildContext context, int position) {
                    return getRow(position);
                }
            ),
            drawer: DrawerNavigation(widget.user, context)
        );
    }


    Widget getRow(int i) {
        return Container(
            height: 64.0,
            margin: EdgeInsets.fromLTRB(24, (16 + (i == 0 ? 8 : 0)).toDouble(), 24, 0 + (i == data?.forms?.length - 1 ? 16 : 0).toDouble()),
            decoration: new BoxDecoration (
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                    BoxShadow(
                        color: Color(0x29000000),
                        blurRadius: 6.0, // has the effect of softening the shadow
                        spreadRadius: 0.0, // has the effect of extending the shadow
                        offset: Offset(
                            0.0, // horizontal, move right 10
                            0.0, // vertical, move down 10
                        ),
                    )
                ],
            ),
            child : ListTile(
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Text(
                                data == null ? "Title" : data.forms[i].title,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400,
                                ),
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xffff2020),
                                    width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Image.asset(
                                "assets/images/ic_fire.png",
                                height: 48.0,
                                width: 48.0,
                            ),
                        ),
                    ],

                ),
                onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(widget.user, data?.forms[i])),);
                },
            ),
        );
    }

    Future<void> getFormsFromServer() async {

        setState(() {
          isLoading = true;
        });

        var getFormsResponse = await http.get("https://emersit.herokuapp.com/api/form/getForms", headers: {"token": widget.user.token},);

        var jsonResponse = json.decode(getFormsResponse.body);

        print("body   ***" + getFormsResponse.body);

        if(jsonResponse['forms'] != null){
            setState(() {
                data = FormList.fromJson(jsonResponse);
            });
        }
        else{
            data = null;
        }

        setState(() {
          isLoading = false;
        });

        print("data  ***" + data.toString());
    }

    void _logout() {
    }

}