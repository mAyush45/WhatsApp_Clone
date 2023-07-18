class UserModel {
  String name;
  String uid;
  String profilePic;
  bool isOnline;
  String phoneNumber;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      name: map?['name'] ?? '',
      uid: map?['uid'] ?? '',
      profilePic: map?['profilePic'] ?? '',
      isOnline: map?['isOnline'] ?? false,
      phoneNumber: map?['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
    };
  }
}
