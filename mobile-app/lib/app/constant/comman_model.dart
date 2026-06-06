class CommonResponseModel<T> {
  bool status;
  String message;
  T? data;

  CommonResponseModel({required this.status, required this.message, this.data});

  factory CommonResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) createData,
  ) {
    return CommonResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? createData(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T?)? convertData) {
    return {
      'status': status,
      'message': message,
      'data': convertData != null && data != null ? convertData(data) : null,
    };
  }
}
