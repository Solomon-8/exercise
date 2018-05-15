


class UserActivityModel{
    int id;
    String activityId;
    String userId;
    String username;

    UserActivityModel(this.id, this.activityId, this.userId, this.username);

    UserActivityModel.fromJson(Map<String, dynamic> json):
                this.id = json['id'],
                this.activityId = json['activityId'],
                this.userId = json['userId'],
                this.username = json['username'];

    Map<String, dynamic> toJson() =>
            {
                'id':id,
                'activityId':activityId,
                'userId':userId,
                'username':username,
            };
}