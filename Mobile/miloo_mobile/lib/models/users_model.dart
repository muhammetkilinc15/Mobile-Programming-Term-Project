class UsersModel {
  final String firstName;
  final String lastName;
  final String userName;
  final String image;

  UsersModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.image,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      image: json['image'],
    );
  }
}
