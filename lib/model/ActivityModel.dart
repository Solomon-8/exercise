


class ActivityModel{

    String activityId;

    String name;

    DateTime date;

    String place;

    int peopleNum;


    ActivityModel(this.activityId, this.name, this.date, this.place,
            this.peopleNum);

    ActivityModel.fromJson(Map<String, dynamic> json):
                this.name = json['name'],
                this.activityId = json['activityId'],
                this.date = new DateTime.fromMillisecondsSinceEpoch(json['date']),
                this.place = json['place'],
                this.peopleNum = json['peopleNum']
    ;

    Map<String, dynamic> toJson() =>
            {
                'name':name,
                'activityId':activityId,
                'date':date,
                'place':place,
                'peopleNum':peopleNum
            };
}