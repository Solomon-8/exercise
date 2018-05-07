

class ResponseModel{
    final bool success;
    final String errMessage;
    final int errCode;
    final String data;

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