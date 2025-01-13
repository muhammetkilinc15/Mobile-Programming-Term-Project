class PopularUserModel {
  String profileImageUrl;
  String userName;

  PopularUserModel({
    required this.profileImageUrl,
    required this.userName,
  });

  factory PopularUserModel.fromJson(Map<String, dynamic> json) {
    return PopularUserModel(
      profileImageUrl: json["profileImageUrl"],
      userName: json["userName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "profileImageUrl": profileImageUrl,
        "userName": userName,
      };
}
