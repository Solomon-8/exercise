import 'package:exercise/main.dart';
import 'package:exercise/model/ActivityModel.dart';
import 'package:exercise/pages/OwnActivityItem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class ActivitiesRecorderPage extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        return new ActivitiesRecorderWidget();
    }

}


class ActivitiesRecorderWidget extends State<StatefulWidget>{
    @override
    Widget build(BuildContext context) {
        getOwnActivities();
        return new Scaffold(
                appBar: new AppBar(title: new Center(child: new Text("活动记录"),),),
                body: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext context, int index) {
                        if(ownItems.length > index){
                            return ownItems[index];
                        }
                    },
                )
        );
    }

}


getOwnActivities()async{
    String activities = domain + "/getOwnActivities";
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
            OwnActivityItem activityItem = new OwnActivityItem(i.name, new DateFormat.MMMd().format(i.date), i.place,i.activityId);
            if(!ownItems.contains(activityItem)){
                ownItems.add(activityItem);
            }
        }
    }
}