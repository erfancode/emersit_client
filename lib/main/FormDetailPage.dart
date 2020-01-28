

import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormDetailPage extends StatefulWidget{

    User user;
    RawForm rawForm;

  FormDetailPage(this.user, this.rawForm);


  @override
  State<StatefulWidget> createState() => _FormDetailPage();


}

class _FormDetailPage extends State<FormDetailPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Text('Under constuction'),
        ),
    );
  }

}