class UserDetailModel {
  int id;
  String firstName;
  String lastName;
  String userName;
  String universityName;
  String profileImageUrl;

  UserDetailModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.universityName,
    required this.profileImageUrl,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      universityName: json['universityName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "userName": userName,
      "universityName": universityName,
      "profileImageUrl": profileImageUrl,
    };
  }
}
