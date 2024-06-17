class ModelClass {
  final String? name;
  final String? email;
  final String? password;
  final String? uid;

  ModelClass({
    required this.name,
    required this.email,
    required this.password,
    required this.uid});

  factory ModelClass.fromFirebase(Map map){
    return ModelClass(
        name: map['name'],
        email: map['email'],
        password: map['password'],
        uid: map['uid']);
  }
}