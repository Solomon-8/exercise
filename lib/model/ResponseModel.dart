

class ResponseModel{
    bool success;
    String errMessage;
    int errCode;
    var data;

    ResponseModel(this.success, this.errMessage, this.errCode, this.data);


    ResponseModel.fromJson(Map<String, dynamic> json)
            :   this.success = json['success'],
                this.errMessage = json['errMessage'],
                this.errCode = json['errCode'],
                this.data = json['data'];

    Map<String, dynamic> toJson() =>
    {
        'success':success,
        'errMessage':errMessage,
        'errCode':errCode,
        'data':data,
    };



}