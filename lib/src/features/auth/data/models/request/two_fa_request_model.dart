
class TwoFactorAuthenticationRequestModel {
  final String? userId;
  final String? secretKey;
  final String? totp;
  final String? deviceId;
  final String? timeLimitInSec;
  final String? numOfDigits;
  final bool? isTotp;

  TwoFactorAuthenticationRequestModel({
    this.userId,
    this.secretKey,
    this.totp,
    this.timeLimitInSec,
    this.deviceId,
    this.numOfDigits,
    this.isTotp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'secretKey': secretKey,
      'isTotp': isTotp,
      'totp': totp,
      'timeLimitInSec': timeLimitInSec,
      'numOfDigits': numOfDigits,
      'deviceId': deviceId,
    };
  }
}
