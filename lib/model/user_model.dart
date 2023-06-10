class UserModel {
  late String name;
  late String phone;
  String image;
  late String uId;

  UserModel({
    required this.name,
    required this.phone,
    this.image =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
    required this.uId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"],
      phone: json["phone"],
      image: json["image"],
      uId: json["uId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "image": image,
      "uId": uId,
    };
  }
}
