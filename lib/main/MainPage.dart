import 'dart:convert';

import 'package:emersit/Network.dart';
import 'package:emersit/main/DrawerNavigation.dart';
import 'package:emersit/main/FormDetailPage.dart';
import 'package:emersit/main/SubmittedFormsPage.dart';
import 'package:emersit/main/FormPage.dart';
import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';

class MainPage extends StatefulWidget {
  User user;

  MainPage(this.user, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  static const String FAILED_GET_FORMS_MESSAGE = "Failed to get forms from server!";
  static const String RETRY_MESSAGE = "Retry";

  FormList data;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getFormsFromServer();
  }

    @override
    Widget build(BuildContext context) {

    Widget retryView = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            FAILED_GET_FORMS_MESSAGE,
            style: TextStyle(
                fontSize: 19.0,
                color: Colors.black,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400),
          ),
          RaisedButton(
            onPressed: getFormsFromServer,
            color: Theme.of(context).primaryColor,
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(24.0),
            ),
            child: isLoading
                ? SizedBox(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xffff2020)),
                    ),
                    height: 24,
                    width: 24,
                  )
                : Text(
                    RETRY_MESSAGE,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ]);

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
                  color: Theme.of(context).primaryColor,
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
                    Utils.APP_NAME,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).primaryColor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                    ),
                  ))
            ],
          ),
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
                height: 32,
                width: 32,
              ))
            : (data == null
                ? retryView
                : ListView.builder(
                    itemCount: data == null ? 0 : data.forms.length,
                    itemBuilder: (BuildContext context, int position) {
                      return getRow(position);
                    })),
        drawer: DrawerNavigation(widget.user, context));

  }

  Widget getRow(int i) {
    return Container(
      height: 64.0,
      margin: EdgeInsets.fromLTRB(24, (16 + (i == 0 ? 8 : 0)).toDouble(), 24,
          0 + (i == data?.forms?.length - 1 ? 16 : 0).toDouble()),
      decoration: new BoxDecoration(
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
      child: ListTile(
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
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.user.role == Network.AGENT_KEY
                    ? FormPage(widget.user, data?.forms[i])
                    : FormDetailPage(widget.user, data?.forms[i])),
          );
        },
      ),
    );
  }

  Future<void> getFormsFromServer() async {
    setState(() {
      isLoading = true;
    });

    Network.getForms(widget.user.token).then((response) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['forms'] != null) {
        setState(() {
          data = FormList.fromJson(jsonResponse);
        });
      } else if (jsonResponse['status'] == 403) {
        data = null;
        _logout(widget.user.token);
      } else {
        data = null;
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void _logout(String token) {
    Utils.logOut(context, token);
  }
}
