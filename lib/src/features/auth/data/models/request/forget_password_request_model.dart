class ForgetPasswordRequestModel {
  final String email;
  final String deviceId;

  ForgetPasswordRequestModel({required this.email, required this.deviceId});

  Map<String, dynamic> toJson() => {'email': email, 'deviceId': deviceId};
}


