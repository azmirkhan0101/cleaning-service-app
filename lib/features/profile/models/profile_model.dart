class ProfileResponseModel {
  final bool success;
  final String message;
  final ProfileModel data;

  ProfileResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProfileModel.fromJson(json['data'] ?? {}),
    );
  }
}

class UpdateProfileResponseModel {
  final bool success;
  final String message;
  final UpdatedProfileData data;

  UpdateProfileResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UpdatedProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UpdatedProfileData {
  final String id;
  final String profilePicture;
  final String userName;
  final String phoneNumber;
  final String address;
  final String? aboutMe;
  final String? experience;

  UpdatedProfileData({
    required this.id,
    required this.profilePicture,
    required this.userName,
    required this.phoneNumber,
    required this.address,
    this.aboutMe,
    this.experience,
  });

  factory UpdatedProfileData.fromJson(Map<String, dynamic> json) {
    return UpdatedProfileData(
      id: json['_id'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      aboutMe: json['aboutMe'],
      experience: json['experience'],
    );
  }
}

class ProfileModel {
  final String id;
  final String userName;
  final String phoneNumber;
  final String email;
  final String role;
  final double latitude;
  final double longitude;
  final String profilePicture;
  final String address;
  final String aboutMe;
  final String experience;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.latitude,
    required this.longitude,
    required this.profilePicture,
    required this.address,
    required this.aboutMe,
    required this.experience,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      latitude: (json['lattitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      profilePicture: json['profilePicture'] ?? '',
      address: json['address'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      experience: json['experience'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'userName': userName,
  //     'phoneNumber': phoneNumber,
  //     'email': email,
  //     'role': role,
  //     'lattitude': latitude,
  //     'longitude': longitude,
  //     'profilePicture': profilePicture,
  //     'status': status,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //   };
  // }
}
