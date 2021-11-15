import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String? name,
    String? email,
    String? uid,
    String? groupName,
    String? color,
  }) : super(
          name: name,
          email: email,
          uid: uid,
          groupName: groupName,
          color: color,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return UserModel(
      name: documentSnapshot['name'],
      email: documentSnapshot['email'],
      uid: documentSnapshot['uid'],
      groupName: documentSnapshot['groupName'],
      color: documentSnapshot['color'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "groupName": groupName,
      "color": color,
    };
  }
}
