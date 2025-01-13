class UserRegisterModel {
  final String userName;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final int universityId;

  UserRegisterModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.universityId,
  });

  Map<String, dynamic> toJson() {
    return {
      "UserName": userName,
      "Email": email,
      "Password": password,
      "firstName": firstName, // PascalCase
      "lastName": lastName, // PascalCase
      "universityId": universityId,
    };
  }
}
