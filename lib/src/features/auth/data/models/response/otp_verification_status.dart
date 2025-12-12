class OtpVerificationStatus {
  final int timeMatched;
  final bool isVerified;

  OtpVerificationStatus({required this.timeMatched, required this.isVerified});

  factory OtpVerificationStatus.fromJson(Map<String, dynamic> json) {
    return OtpVerificationStatus(
      timeMatched: json['timeMatched'] ?? 0,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'timeMatched': timeMatched, 'isVerified': isVerified};
  }

  @override
  String toString() =>
      'OtpVerificationStatus(timeMatched: $timeMatched, isVerified: $isVerified)';
}


