class UserModel {
  String? email;
  String? password;

  UserModel({this.email, this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(email: map['email'], password: map['password']);
  }
}
