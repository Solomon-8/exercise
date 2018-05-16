import 'package:exercise/main.dart';
import 'package:exercise/model/ActivityModel.dart';
import 'package:exercise/pages/ActivityItem.dart';
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
            String temp = new DateFormat.yMd().add_Hm().format(i.date);
            print(temp);
            ActivityItem activityItem = new ActivityItem(i.name,temp, i.place,i.activityId);
            if(!items.contains(activityItem)){
                items.add(activityItem);
            }
        }
    }
}