

import 'dart:convert';

import 'package:emersit/Network.dart';
import 'package:emersit/main/FormReportDetailPage.dart';
import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/SubmittedFormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';

import '../Utils.dart';
import 'DrawerNavigation.dart';

class FormReportPage extends StatefulWidget{

    User user;
    RawForm rawForm;

    FormReportPage(this.user, this.rawForm);


  @override
  State<StatefulWidget> createState() => _FormDetailPage();


}

class _FormDetailPage extends State<FormReportPage>{

    static const String FAILED_GET_FORMS_MESSAGE = "Failed to get forms from server!";
    static const String RETRY_MESSAGE = "Retry";

    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    SubmittedFormList data;
    GeoJsonFeatureCollection locations;

    List<Forms> filteredForms;

    bool isLoading = false;

    List<TableRow> mRows;

    @override
    void initState() {
        super.initState();

        getLocations();
        getFormReport();

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
                        onPressed: () {
                            if(data == null)
                                getFormReport;
                            if(locations == null)
                                getLocations();
                        },
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
                key: scaffoldKey,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                        iconTheme: new IconThemeData(color: Color(0xffff2020)),
                        backgroundColor: Colors.white,
                        title: Align(
                            alignment: Alignment.center,
                            child: Container(
                                    child: Text(
                                        widget.rawForm.title + " Report",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w500,
                                        ),
                                    )
                            ),
                        )
                ),
                body: isLoading ? Center(
                        child: SizedBox(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor),
                            ),
                            height: 32,
                            width: 32,
                        )) : ((data == null || locations == null) ? retryView :
                SingleChildScrollView(
                    child : Stack(
                        children: <Widget>[
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                    ),
                                    margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                                    child: Image.asset(
                                        "assets/images/logo.png",
                                        height: 72.0,
                                        width: 72.0,
                                    ),
                                ),
                            ),
                            Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(0, 104, 0, 0),
                                        child: Text(
                                            "Emersit",
                                            style: TextStyle(
                                                fontSize: 34.0,
                                                color: Theme.of(context).primaryColor,
                                                fontFamily: "Roboto",
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                    )
                            ),
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    width: 500,
                                    margin: const EdgeInsets.fromLTRB(16, 176, 16, 24),
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                            width: widget.rawForm.fields.length * 100.0,
                                            child: Table(
                                                border: TableBorder.all(),
                                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                children: mRows,
                                            ),
                                        )
                                    )
                                ),
                            ),
                        ],
                    )
                )),
                drawer: DrawerNavigation(widget.user, context)
        );
    }

    void getFormReport() async {

      setState(() {
          isLoading = true;
      });

      Network.getFormReport(widget.rawForm.id , widget.user.token).then((response) {
          var jsonResponse = json.decode(response.body);

          if (jsonResponse['forms'] != null) {
              setState(() {
                  data = SubmittedFormList.fromJson(jsonResponse);
                  filteredForms = data.forms;
                  setRows(data.forms);
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

    void getLocations() async{

        setState(() {
            isLoading = true;
        });

        Network.getLocations(widget.user.token).then((response) async {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse['features'] != null) {

                var features = { "features" : jsonResponse['features']};

                var newLocations = await featuresFromGeoJson(jsonEncode(features));

                setState(() {
                    locations = newLocations;

                    isLoading = false;
                });

            } else if (jsonResponse['status'] == 403) {
                locations = null;
                setState(() {
                    isLoading = false;
                });
                _logout(widget.user.token);
            } else {
                locations = null;
                setState(() {
                    isLoading = false;
                });
            }
        });

    }

    void setRows(List<Forms> forms){

            mRows = [];

            //region header
            List<FittedBox> row = [];

            row.add(new FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                        child : Text(
                            "username",
                            style: TextStyle(
                                    color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),
                        )
                ),
            ));

            for(Field field in widget.rawForm.fields){

                row.add(new FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                            child : Text(
                                field.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900
                                ),
                            )
                        )
                ));
            }

            mRows.add(new TableRow(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                ),
                children: row
            ));

            //endregion

            //region body
            for(Forms form in forms){
                List<Center> roww = [];

                roww.add(new Center(
                    child: Text(
                        form.username,
                    ),
                ));


                for(Field ffield in widget.rawForm.fields){
                    var value = "";

                    for(Data field in form.data){

                        if(field.name == ffield.name){

                            if(ffield.type == "Location"){
                                value = field.value;
                            }
                            else {
                                value = field.value;
                            }
                            break;
                        }
                    }

                    roww.add(new Center(
                        child: Text(
                            value,
                        ),
                    ));
                }

                mRows.add(new TableRow(
                        decoration: BoxDecoration(
                            color: Colors.white,
                        ),
                        children: roww
                ));
            }
            //endregion

            //region Sum
            List<Container> sumRow= [];

            sumRow.add(new Container(
                height: 40,
                alignment: Alignment(0.0, 0.0),
                child: Text(
                    "Sum",
                ),
            ));

            for(Field ffield in widget.rawForm.fields){
                var count = -1;


                if(ffield.type == "Number"){
                    for(Forms form in forms){
                        for(Data field in form.data){

                            if(field.name == ffield.name){
                                count += int.parse(field.value);
                                break;
                            }
                        }

                    }
                }

                count++;

                sumRow.add(new Container(
                    alignment: Alignment(0.0, 0.0),
                    child: Text(
                        count == 0 ? "" : count.toString(),
                    ),
                ));
            }

            mRows.add(new TableRow(
                    decoration: BoxDecoration(
                        color: Colors.white,
                    ),
                    children: sumRow
            ));

            //endregion
      }

    void _logout(String token) {
        Utils.logOut(context, token);
    }

}