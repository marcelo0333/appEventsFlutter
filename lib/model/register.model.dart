class UserDTO {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imgUser;

  UserDTO({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.imgUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}
