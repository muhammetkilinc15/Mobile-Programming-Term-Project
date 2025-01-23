class UserVerifyEmail {
  final String email;
  final String code;

  UserVerifyEmail({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Code": code,
    };
  }
}
