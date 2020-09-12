class Operator {
  String username;
  String password;

  Operator({this.username, this.password});

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      username: json['username'],
      password: json['password'],
    );
  }
}
