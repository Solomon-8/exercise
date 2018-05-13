import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:exercise/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    String peopleNum;
    DateTime selectedDate = new DateTime.now();
    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 28);

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            body: new SingleChildScrollView(
                child: new Column(
                    children: <Widget>[
                        new Form(
                                child: new Column(
                                    children: <Widget>[
                                        new TextFormField(
                                            decoration: const InputDecoration(
                                                    icon: const Text("活动名称",style: const TextStyle(fontSize: 18.0),),
                                                    border: const UnderlineInputBorder(),
                                                    hintText: '自定义'
                                            ),
                                            onSaved: (String value){name = value;},
                                            keyboardType: TextInputType.text,
                                        ),
                                        new TextFormField(
                                            decoration: const InputDecoration(
                                                    icon: const Text("活动地点",style: const TextStyle(fontSize: 18.0),),
                                                    border: const UnderlineInputBorder(),
                                                    hintText: '自定义'
                                            ),
                                            onSaved: (String value){place = value;},
                                            keyboardType: TextInputType.text,
                                        ),
                                        new TextFormField(
                                            decoration: const InputDecoration(
                                                    icon: const Text("活动人数",style: const TextStyle(fontSize: 18.0),),
                                                    border: const UnderlineInputBorder(),
                                                    hintText: '自定义'
                                            ),
                                            onSaved: (String value){peopleNum = value;},
                                            keyboardType: TextInputType.number,
                                        ),
                                        new _DateTimePicker(
                                            labelText: "活动日期",
                                            selectedDate: selectedDate,
                                            selectDate: ((DateTime date){
                                                selectedDate = date;
                                            }),
                                            type: 1,
                                        ),
                                        new _DateTimePicker(
                                            labelText: "活动时间",
                                            selectedTime: selectedTime,
                                            selectTime: ((TimeOfDay time){
                                                selectedTime = time;
                                            }),
                                            type: 2,
                                        ),
                                        const SizedBox(height: 120.0,),
                                        new RaisedButton(
                                            color: Colors.white,
                                            child: const Text("发布活动"),
                                            padding: const EdgeInsets.only(left: 120.0,right: 120.0),
                                            onPressed: (){doAddActivity(context);},
                                        ),
                                        const SizedBox(height: 1.0,),
                                    ],
                                ),
                            key: _addActivityForm,
                        )
                    ],
                )
            ),
        );
    }

    Future doAddActivity(context)async {
        var uuid = new Uuid();
        final FormState formState = _addActivityForm.currentState;
        print("get formState");
        formState.save();
        DateTime dateTime = new DateTime(selectedDate.year,selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute);
        String addActivity = domain + "/postActivity";
        String post = json.encode({"activityId":uuid.v1(),"name":name,"date":dateTime.millisecondsSinceEpoch,"place":place,"peopleNum":peopleNum});
        print(post);
        String result;
        await http.post(addActivity,body: post,headers: {'Content-Type':'application/json','cookie':cookie}).then((response){
            print("Response body : ${response.body}");
            print("Response Code : ${response.statusCode}");
            result = response.body;
        });
        var response = getResponseFromJson(result);
        if(response.success == true){
            shwoSuccess(context, "发布活动成功");
        }else{
            showError(context, response.errMessage);
        }
    }

}


class _InputDropdown extends StatelessWidget {
    const _InputDropdown({
        Key key,
        this.child,
        this.labelText,
        this.valueText,
        this.valueStyle,
        this.onPressed }) : super(key: key);

    final String labelText;
    final String valueText;
    final TextStyle valueStyle;
    final VoidCallback onPressed;
    final Widget child;

    @override
    Widget build(BuildContext context) {
        return new InkWell(
            onTap: onPressed,
            child: new Column(
                children: <Widget>[
                    new InputDecorator(
                        decoration: new InputDecoration(
                            labelText: labelText,
                        ),
                        baseStyle: valueStyle,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                new Text(valueText, style: valueStyle),
                                new Icon(Icons.arrow_drop_down,
                                        color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
                                ),
                            ],
                        ),
                    ),
                ],
            )
        );
    }
}

class _DateTimePicker extends StatelessWidget {
    const _DateTimePicker({
        Key key,
        this.labelText,
        this.selectedDate,
        this.selectedTime,
        this.selectDate,
        this.selectTime,
        this.type
    }) : super(key: key);

    final String labelText;
    final DateTime selectedDate;
    final TimeOfDay selectedTime;
    final ValueChanged<DateTime> selectDate;
    final ValueChanged<TimeOfDay> selectTime;
    final int type;
    Future<Null> _selectDate(BuildContext context) async {
        final DateTime picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: new DateTime(2015, 8),
                lastDate: new DateTime(2101)
        );
        if (picked != null && picked != selectedDate)
            selectDate(picked);
    }

    Future<Null> _selectTime(BuildContext context) async {
        final TimeOfDay picked = await showTimePicker(
                context: context,
                initialTime: selectedTime
        );
        if (picked != null && picked != selectedTime)
            selectTime(picked);
    }

    @override
    Widget build(BuildContext context) {
        final TextStyle valueStyle = Theme.of(context).textTheme.title;
        if(type == 1){
            return new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    new Text(labelText,style: new TextStyle(fontSize: 18.0)),
                    const SizedBox(width: 12.0),
                    new Expanded(
                        flex: 4,
                        child: new _InputDropdown(
                            valueText: new DateFormat.yMMMd().format(selectedDate),
                            valueStyle: valueStyle,
                            onPressed: () { _selectDate(context); },
                        ),
                    ),
                ],
            );
        }else{
            return new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    new Text(labelText,style: new TextStyle(fontSize: 18.0),),
                    const SizedBox(width: 12.0),
                    new Expanded(
                        flex: 4,
                        child: new _InputDropdown(
                            valueText: selectedTime.format(context),
                            valueStyle: valueStyle,
                            onPressed: () { _selectTime(context); },
                        ),
                    ),
                ],
            );
        }

    }
}




