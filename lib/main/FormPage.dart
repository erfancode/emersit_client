

import 'dart:convert';

import 'package:emersit/Network.dart';
import 'package:emersit/model/SubmitForm.dart';
import 'package:http/http.dart' as http;
import 'package:emersit/main/DrawerNavigation.dart';
import 'package:emersit/model/FormList.dart';
import 'package:emersit/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../Utils.dart';

class FormPage extends StatefulWidget{

  RawForm form;
  User user;

  FormPage(this.user, this.form, {Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _FormPageState();

}

class _FormPageState extends State<FormPage>{

    static const String SUBMIT_SUCCESSFULLY_MESSAGE = 'Form sent successfully.';
    static const String SUBMIT_FAILED_MESSAGE = 'Failed to send form.';
    static const String SUBMIT_REQUIRE_FILL_MESSAGE = 'Fill required fields!';

    static const String SUBMIT_TEXT = 'SUBMIT';

    static const LatLng INITIAL_LOCATION = LatLng(35.8020383, 51.3931292);

    static const String SELECT_DATE_TEXT = 'Select Date';
    static const String SELECT_LOCATION_TEXT = 'Select Location';

    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

    List<String> answers;

    bool isSending = false;

    @override
    void initState() {
        super.initState();

        answers = List(widget.form.fields.length);
    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
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
                        )
                    )
                ],
            ),
        ),
        drawer: DrawerNavigation(widget.user, context),
        body: ListView.builder(
            itemCount: widget.form.fields.length + 1,
            itemBuilder: (BuildContext context, int position) {
                if(position != widget.form.fields.length)
                    return getRow(position);
                else
                    return Container(
                        height: 48.0,
                        margin: EdgeInsets.fromLTRB(24, (16 + (position == 0 ? 8 : 0)).toDouble(), 24, 16),
                        child : RaisedButton(
                            onPressed: isSending ? null : _submit,
                            color: Theme.of(context).primaryColor,
                            splashColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(24.0),
                            ),
                            child: isSending ? SizedBox(
                                child : CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                ),
                                height: 24,
                                width: 24,
                            )
                            : Text(
                                SUBMIT_TEXT,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        ),
                    );
        }
      ),
    );
  }

  Widget getRow(int i) {

      Field field = widget.form.fields[i];

      switch(field.type){
          case Utils.QUESTION_TYPE_TEXT : {

              return Container(
                  height: 48.0,
                  margin: EdgeInsets.fromLTRB(24, (16 + (i == 0 ? 8 : 0)).toDouble(), 24, 0 + (i == widget.form.fields.length - 1 ? 16 : 0).toDouble()),
                  decoration: new BoxDecoration (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                  ),
                  child : TextField(
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: field.title,
                          prefixIcon: Icon(Icons.question_answer),
                          border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 32.0),
                                  borderRadius: BorderRadius.circular(24.0)),
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                          answers[i] = text;
                      },
                  ),
              );

          }
          case Utils.QUESTION_TYPE_NUMBER : {

              return Container(
                  height: 48.0,
                  margin: EdgeInsets.fromLTRB(24, (16 + (i == 0 ? 8 : 0)).toDouble(), 24, 0 + (i == widget.form.fields.length - 1 ? 16 : 0).toDouble()),
                  decoration: new BoxDecoration (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                  ),
                  child : TextField(
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          labelText: field.title,
                          prefixIcon: Icon(Icons.question_answer),
                          border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 32.0),
                                  borderRadius: BorderRadius.circular(24.0)),
                      ),
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                      onChanged: (text) {
                          answers[i] = text;
                      },
                  ),
              );
          }
          case Utils.QUESTION_TYPE_DATE : {

              DateTime selectedDate = DateTime.now();

              return Container(
                  height: 48.0,
                  margin: EdgeInsets.fromLTRB(24, (16 + (i == 0 ? 8 : 0)).toDouble(), 24, 0 + (i == widget.form.fields.length - 1 ? 16 : 0).toDouble()),
                  decoration: new BoxDecoration (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                  ),
                  child : RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                          side: BorderSide(color: Colors.grey)
                      ),
                      onPressed: () async {

                          final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime.now());
                          if (picked != null && picked != selectedDate) {

                              answers[i] = DateFormat('dd/MM/yyyy hh:mm:ss').format(picked);
                              setState(() {
                                  selectedDate = picked;
                              });
                          }
                      },
                      child: Text(
                          field.title + (answers[i] == null ? '' : ' : ${answers[i].split(" ")[0]}')
                      ),
                  ),
              );
          }
          case Utils.QUESTION_TYPE_LOCATION : {

              return Container(
                  height: 48.0,
                  margin: EdgeInsets.fromLTRB(24, (16 + (i == 0 ? 8 : 0)).toDouble(), 24, 0 + (i == widget.form.fields.length - 1 ? 16 : 0).toDouble()),
                  decoration: new BoxDecoration (
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                  ),
                  child : RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(24.0),
                              side: BorderSide(color: Colors.grey)
                      ),
                      onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                      apiKey: Utils.GOOGLE_API_KEY,   // Put YOUR OWN KEY here.
                                      onPlacePicked: (result) {
                                          answers[i] = result.geometry.location.lat.toStringAsFixed(7) + "," +result.geometry.location.lng.toStringAsFixed(7);
                                          print(answers[i]);
                                          Navigator.of(context).pop();
                                          setState(() { });
                                      },
                                      initialPosition: INITIAL_LOCATION,
                                      useCurrentLocation: true,
                                  ),
                              ),
                          );
                      },
                      child: Text(field.title + " " + (answers[i] == null || answers[i].length == 0 ? '' : answers[i])),
                  ),
              );
          }
      }
  }


  Future<void> _submit() async {

        bool isValidate = true;

        for(int i = 0; i < answers.length; i++){

            if(widget.form.fields[i].required != null && widget.form.fields[i].required && answers[i] == null){
                isValidate = false;
                break;
            }
        }

        if(isValidate){
            setState(() {
              isSending = true;
            });

            SubmitForm data = SubmitForm(widget.form.id, widget.user.username, widget.form.title, widget.form.type, DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now()));
            for(int i = 0; i < answers.length; i++){

                if(answers[i] != null){
                    data.addKeyValue(widget.form.fields[i].name, answers[i]);
                }
            }

            print(data.toJson());


            Network.submitForm(widget.user.token, json.encode(data.toJson())).then( (response) {
                if(response.statusCode == 200){

                    Navigator.pop(context);
                    makeSnack(SUBMIT_SUCCESSFULLY_MESSAGE);
                }
                else if(response.statusCode == 403){
                    Utils.logOut(context, widget.user.token);
                }
                else{
                    makeSnack(SUBMIT_FAILED_MESSAGE);
                }

                setState(() {
                    isSending = false;
                });
            });
        }
        else{
            makeSnack(SUBMIT_REQUIRE_FILL_MESSAGE);
        }
  }

  void makeSnack(String message){
      scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(
              message,
              style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
              ),
          ),

          duration: Duration(milliseconds: 1500),
          backgroundColor: Theme.of(context).primaryColor,
      ));
  }
}