class Profile {
  String fullName;
  DateTime dateOfBirth;
  String email;
  String gender;
  String profilePicture;

  Profile({
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.gender,
    required this.profilePicture,
  });

  Profile copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? email,
    String? gender,
    String? profilePicture,
  }) {
    return Profile(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
