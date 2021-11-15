import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String? name;
  String? email;
  String? uid;
  String? groupName;
  String? color;

  UserEntity({this.name, this.email, this.uid, this.groupName, this.color});

  @override
  // TODO: implement props
  List<Object?> get props => [name, email, uid, groupName, color];
}
