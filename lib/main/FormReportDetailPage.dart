

import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormReportDetailPage extends StatefulWidget{

    User user;
    List<RawForm> forms;

    FormReportDetailPage(this.user, this.forms);

  @override
  State<StatefulWidget> createState() => _FormReportDetailState();

}

class _FormReportDetailState extends State<FormReportDetailPage>{




  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }


}