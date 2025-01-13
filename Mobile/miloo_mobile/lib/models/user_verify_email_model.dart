class UserVerifyEmail {
  final String Email;
  final String Code;

  UserVerifyEmail({
    required this.Email,
    required this.Code,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": Email,
      "Code": Code,
    };
  }
}
