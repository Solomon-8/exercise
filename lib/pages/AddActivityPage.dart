import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddActivityPage extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        return new AddActivityWidget();
    }

}


class AddActivityWidget extends State<AddActivityPage>{
    final GlobalKey<FormState> _addActivityForm = new GlobalKey<FormState>();
    String name;
    DateTime dateTime;
    String place;
    int peopleNum;
    DateTime selectedDate = new DateTime.now();
    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 28);

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            body: new Container(
                    height: 120.0,
                child: new Column(
                    children: <Widget>[
                        new Form(child: new Column(
                            key: _addActivityForm,
                            children: <Widget>[
                                new TextFormField(
                                    decoration: const InputDecoration(
                                        icon: const Text("活动名称"),
                                        border: const UnderlineInputBorder(),
                                        hintText: '自定义'
                                    ),
                                    onSaved: (String value){name = value;},
                                    keyboardType: TextInputType.text,
                                ),

                            ],
                        ))
                    ],
                )
            ),
        );
    }

}




