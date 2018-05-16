import 'package:exercise/main.dart';
import 'package:exercise/model/ActivityModel.dart';
import 'package:exercise/model/UserActivityModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;



class ActivityPage extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        return new ActivityWidget();
    }

}


class ActivityWidget extends State<StatefulWidget>{
    @override
    Widget build(BuildContext context) {
        getActivities();
        return new Scaffold(
            body: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                    if(items.length > index){
                        return items[index];
                    }
                },
            )
        );
    }

}



class ActivityItem extends StatelessWidget{
    String _title;
    String _time;
    String _place;
    String _activityId;

    @override
    bool operator ==(other) {
        return this._activityId == (other as ActivityItem)._activityId;
    }


    ActivityItem(this._title, this._time, this._place, this._activityId);

    @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            border: new Border(
                bottom: Divider.createBorderSide(context,width: 1.0,color: Colors.black12)
            )
        ),
        child: new Column(
            children: <Widget>[
                new Text(_title,
                    style: const TextStyle(fontSize: 20.0),
                ),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        new Column(
                            children: <Widget>[
                                new Text(_time),
                                new SizedBox(height: 6.0,),
                                new Text(_place),
                                new SizedBox(height: 8.0,),
                                new RaisedButton(
                                    shape:const RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(const Radius.circular(8.0))
                                    ) ,
                                    color: Colors.white,
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                    onPressed: (){doActivitiesPeople(context);},
                                    child: new Text("活动人员"),
                                )
                            ],
                        ),
                        new Column(
                            children: <Widget>[
                                new RaisedButton(
                                    shape:const RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(const Radius.circular(8.0))
                                    ) ,
                                    onPressed: (){doLeaveMessage(context);},
                                    child: new Text("留言"),
                                    color: Colors.white,
                                ),
                                new SizedBox(height: 8.0,),
                                new RaisedButton(
                                    shape:const RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(const Radius.circular(8.0))
                                    ) ,
                                    onPressed: (){doJoinActivity(context);},
                                    child: new Text("立即报名"),
                                    color: Colors.blueAccent,
                                    textColor: Colors.white,
                                )
                            ],
                        ),
                    ],
                ),
            ],
        ),
    );
  }
    doActivitiesPeople(context) async{
        String getPeople = domain + "/getJoinPeople?activityId="+_activityId;
        String result;
        await http.get(getPeople,headers: {'Content-Type':'application/json','cookie':cookie}).then((response){
            print("Response body : ${response.body}");
            print("Response Code : ${response.statusCode}");
            result = response.body;
        });
        var response = getResponseFromJson(result);
        if(response.success == true){
            List<UserActivityModel> content = getUserActivityFromJson(response.data);
            String showName = "当前报名的人有:\n";
            if(content.length == 0){
                shwoSuccess(context,"当前活动没有人报名");
            }else{
                for(int i= 0 ; i < content.length; i++){
                    showName += content[i].username+"\n";
                }
                shwoSuccess(context,showName);
            }
        }else{
            showError(context, response.errMessage);
        }
    }

    doLeaveMessage(context)async {
        showInput(context,_activityId);
    }

    doJoinActivity(context)async {
        String join = domain + "/joinActivity"+"?activityId="+_activityId;
        String result;
        await http.get(join,headers: {'Content-Type':'application/json','cookie':cookie}).then((response){
            print("Response body : ${response.body}");
            print("Response Code : ${response.statusCode}");
            result = response.body;
        });
        var response = getResponseFromJson(result);
        if(response.success == true){
            shwoSuccess(context, "加入活动成功");
        }else{
            showError(context, response.errMessage);
        }
    }

}
getActivities()async{
    String activities = domain + "/getActivitiesList";
    String result;
    await http.get(activities,headers: {'Content-Type':'application/json','cookie':cookie}).then((response){
        print("Response body : ${response.body}");
        print("Response Code : ${response.statusCode}");
        result = response.body;
    });
    var response = getResponseFromJson(result);
    if(response.success == true){
        List<ActivityModel> activities = getActivityFromJson(response.data);
        for(ActivityModel i in activities){
            ActivityItem activityItem = new ActivityItem(i.name, new DateFormat.MMMd().format(i.date), i.place,i.activityId);
            if(!items.contains(activityItem)){
                items.add(activityItem);
            }
        }
    }
}