class SignupRequestModel {
  String userCode;
  String username;
  String password;
  String erpId;
  String erpPassword;
  String email;
  String countryCode;
  String cellNo;
  String defaultWarehouse;
  String userGroup;
  bool locked;
  String? picture;
  bool superUser;
  bool receiver;
  bool allowAllWhs;
  String version;

  SignupRequestModel({
    required this.userCode,
    required this.username,
    required this.password,
    required this.erpId,
    required this.erpPassword,
    required this.email,
    required this.countryCode,
    required this.cellNo,
    required this.defaultWarehouse,
    required this.userGroup,
    required this.locked,
    required this.picture,
    required this.superUser,
    required this.receiver,
    required this.allowAllWhs,
    required this.version,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) {
    return SignupRequestModel(
      userCode: json['user_code'],
      username: json['username'],
      password: json['password'],
      erpId: json['erp_id'],
      erpPassword: json['erp_password'],
      email: json['email'],
      countryCode: json['country_code'],
      cellNo: json['cell_no'],
      defaultWarehouse: json['dlft_whs'],
      userGroup: json['user_group'],
      locked: json['locked'],
      picture: json['picture'],
      superUser: json['super_user'],
      receiver: json['receiver'],
      allowAllWhs: json['allow_all_whs'],
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_code': userCode,
      'username': username,
      'password': password,
      'erp_id': erpId,
      'erp_password': erpPassword,
      'email': email,
      'country_code': countryCode,
      'cell_no': cellNo,
      'dlft_whs': defaultWarehouse,
      'user_group': userGroup,
      'locked': locked,
      'picture': picture,
      'super_user': superUser,
      'receiver': receiver,
      'allow_all_whs': allowAllWhs,
      'version': version,
    };
  }
}
