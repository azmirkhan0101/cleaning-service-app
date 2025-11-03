/*
Provider Response:
{
    "success": true,
    "message": "Registration completed successfully",
    "data": {
        "_id": "68f5c01643e14820603fd414",
        "userName": "Jane Doe",
        "phoneNumber": "0123459784",
        "email": "jane@gmail.com",
        "registrationStatus": "COMPLETED",
        "resultRange": 10,
        "plan": "BASIC",
        "status": "ACTIVE",
        "isEmailVerified": true,
        "isDeleted": false,
        "createdAt": "2025-10-20T04:52:38.295Z",
        "updatedAt": "2025-10-20T05:09:53.344Z",
        "__v": 0,
        "NIDBack": "https://res.cloudinary.com/...",
        "NIDFront": "https://res.cloudinary.com/...",
        "experience": "2-5",
        "lattitude": 45.42472,
        "longitude": 75.695,
        "profilePicture": "https://res.cloudinary.com/...",
        "role": "PROVIDER",
        "selfieWithNID": "https://res.cloudinary.com/..."
    }
}

Owner Response:
{
    "success": true,
    "message": "Registration completed successfully",
    "data": {
        "_id": "68f472e42495acd39a1b31cd",
        "userName": "John Doe",
        "phoneNumber": "0123459789",
        "email": "john@gmail.com",
        "registrationStatus": "COMPLETED",
        "resultRange": 25,
        "plan": "BASIC",
        "status": "ACTIVE",
        "isEmailVerified": true,
        "isPhoneVerified": false,
        "loginAttempts": 0,
        "isDeleted": false,
        "createdAt": "2025-10-19T05:11:00.204Z",
        "updatedAt": "2025-10-19T05:20:24.542Z",
        "__v": 0,
        "lattitude": 40.7128,
        "longitude": -74.06,
        "role": "OWNER"
    }
}
*/

class ProfileSetupResponseModel {
  final String id;
  final String userName;
  final String phoneNumber;
  final String email;
  final String registrationStatus;
  final double resultRange;
  final String plan;
  final String status;
  final bool isEmailVerified;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? latitude;
  final double? longitude;
  final String role;

  // Provider specific fields
  final String? nidBack;
  final String? nidFront;
  final String? experience;
  final String? profilePicture;
  final String? selfieWithNid;

  // Owner specific fields
  final bool? isPhoneVerified;
  final int? loginAttempts;

  ProfileSetupResponseModel({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.registrationStatus,
    required this.resultRange,
    required this.plan,
    required this.status,
    required this.isEmailVerified,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    required this.role,
    this.nidBack,
    this.nidFront,
    this.experience,
    this.profilePicture,
    this.selfieWithNid,
    this.isPhoneVerified,
    this.loginAttempts,
  });

  factory ProfileSetupResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileSetupResponseModel(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      registrationStatus: json['registrationStatus'] ?? '',
      resultRange: (json['resultRange'] ?? 0).toDouble(),
      plan: json['plan'] ?? '',
      status: json['status'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      latitude: json['lattitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      role: json['role'] ?? '',
      // Provider specific
      nidBack: json['NIDBack'],
      nidFront: json['NIDFront'],
      experience: json['experience'],
      profilePicture: json['profilePicture'],
      selfieWithNid: json['selfieWithNID'],
      // Owner specific
      isPhoneVerified: json['isPhoneVerified'],
      loginAttempts: json['loginAttempts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'email': email,
      'registrationStatus': registrationStatus,
      'resultRange': resultRange,
      'plan': plan,
      'status': status,
      'isEmailVerified': isEmailVerified,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lattitude': latitude,
      'longitude': longitude,
      'role': role,
      if (nidBack != null) 'NIDBack': nidBack,
      if (nidFront != null) 'NIDFront': nidFront,
      if (experience != null) 'experience': experience,
      if (profilePicture != null) 'profilePicture': profilePicture,
      if (selfieWithNid != null) 'selfieWithNID': selfieWithNid,
      if (isPhoneVerified != null) 'isPhoneVerified': isPhoneVerified,
      if (loginAttempts != null) 'loginAttempts': loginAttempts,
    };
  }
}
