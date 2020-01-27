

import 'package:emersit/main/DrawerNavigation.dart';
import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget{

  RawForm form;
  User user;
  FormPage(this.user, this.form, {Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _FormPageState();


}

class _FormPageState extends State<FormPage>{


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
            Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.form.title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                      ),
                    ))
          ],

        ),
      ),
      drawer: DrawerNavigation(widget.user, context)
    );
  }

}