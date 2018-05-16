


class MessageModel{
    String content;

    DateTime time;

    String activityId;

    String messageId;


    MessageModel(this.content, this.activityId, this.messageId);

    MessageModel.fromJson(Map<String, dynamic> json):
                this.content = json['content'],
                this.activityId = json['activityId'],
                this.time = new DateTime.fromMillisecondsSinceEpoch(json['time']),
                this.messageId = json['messageId'];


    Map<String, dynamic> toJson() =>
            {
                'content':content,
                'activityId':activityId,
                'time':time,
                'messageId':messageId,
            };

}