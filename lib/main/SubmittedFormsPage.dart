
import 'dart:convert';

import 'package:emersit/Network.dart';
import 'package:emersit/Utils.dart';
import 'package:emersit/main/DrawerNavigation.dart';
import 'package:emersit/model/SubmittedFormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmittedFormsPage extends StatefulWidget{

    User user;

    SubmittedFormsPage(this.user, {Key key}) : super(key : key);

  @override
  State<StatefulWidget> createState() => _SubmittedFormsPage();

}

class _SubmittedFormsPage extends State<SubmittedFormsPage>{

    static const String FAILED_GET_FORMS_MESSAGE = "Failed to get forms from server!";
    static const String RETRY_MESSAGE = "Retry";

    SubmittedFormList data;
    bool isLoading = false;

    @override
  void initState() {
    super.initState();

    getSubmittedForms();
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
                      onPressed: getSubmittedForms,
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
            child: GestureDetector(
                onTap: () => {
                    //todo
                },
                child: Stack(
                    children: [
                        Align(alignment: Alignment.centerLeft,
                            child: Container(
                                    margin: const EdgeInsets.fromLTRB(16, 0, 0, 24),
                                    child: Text(
                                        (data.forms[i].formName == null ? '' : data.forms[i].formName),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400,
                                        ),
                                    )),
                        ),
                        Align(alignment: Alignment.bottomLeft,
                            child: Row(
                                children: <Widget>[
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(16, 0, 0, 6),
                                        child: Icon(
                                            Icons.calendar_today,
                                            size: 12.0,
                                            color: Color(0xff9e9e9e),
                                        ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(6, 0, 0, 6),
                                        child: Text(
                                            data.forms[i].date.split("T").elementAt(0),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Color(0xff9e9e9e),
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400,
                                            ),
                                        ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(42, 0, 0, 6),
                                        child: Icon(
                                            Icons.access_time,
                                            size: 12.0,
                                            color: Color(0xff9e9e9e),
                                        ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(6, 0, 0, 6),
                                        child: Text(
                                            data.forms[i].date.split("T").elementAt(1).split(":").getRange(0, 2).toString().replaceAll("(", "").replaceAll(")", "").replaceAll(", ", ":"),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Color(0xff9e9e9e),
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.w400,
                                            ),
                                        ),
                                    ),


                                ],
                            ),
                        ),
                        Align(alignment: Alignment.centerRight,
                            child: Container(
                                width: 48,
                                height: 48,
                                margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Center(
                                    child : Image.asset(
                                        Utils.getSituationTypeIconAsset(data.forms[i].type),
                                        height: 32.0,
                                        width: 32.0,
                                    ),
                                ),
                            ),
                        ),
                    ],
                )
            )
        );
    }

    Future<void> getSubmittedForms() async {
        setState(() {
            isLoading = true;
        });

        Network.getSubmittedForms(widget.user.username, widget.user.token).then((response) {
            var jsonResponse = json.decode(response.body);

            if (jsonResponse['forms'] != null) {
                setState(() {
                    data = SubmittedFormList.fromJson(jsonResponse);
                });
            } else if (jsonResponse['status'] == 403) {
                data = null;
                Utils.logOut(context, widget.user.token);
            } else {
                data = null;
            }

            setState(() {
                isLoading = false;
            });
        });
    }

}