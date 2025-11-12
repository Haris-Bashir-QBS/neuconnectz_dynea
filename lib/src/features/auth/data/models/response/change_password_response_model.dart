class ChangePasswordDataModel {
  final String message;

  ChangePasswordDataModel({
    required this.message,
  });

  factory ChangePasswordDataModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordDataModel(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
  };
} 