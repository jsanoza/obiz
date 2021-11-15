import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_app_request/feature/data/remote/data_sources/firebase_remote_data_source.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<void> addNewNote(NoteEntity noteEntity) async {
    return firebaseRemoteDataSource.addNewNote(noteEntity);
  }

  @override
  Future<void> deleteNewNote(NoteEntity noteEntity) async {
    return firebaseRemoteDataSource.deleteNewNote(noteEntity);
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity userEntity) async {
    return firebaseRemoteDataSource.getCreateCurrentUser(userEntity);
  }

  @override
  Stream<List<NoteEntity?>> getNotes(String uid, String group) {
    return firebaseRemoteDataSource.getNotes(uid, group);
  }

  @override
  Future<void> signIn(UserEntity userEntity) async {
    return firebaseRemoteDataSource.signIn(userEntity);
  }

  @override
  Future<void> signUp(UserEntity userEntity) async {
    return firebaseRemoteDataSource.signUp(userEntity);
  }

  @override
  Future<void> updateNote(NoteEntity noteEntity) async {
    return firebaseRemoteDataSource.updateNote(noteEntity);
  }

  Future<bool> isSignedIn() async {
    return firebaseRemoteDataSource.isSignedIn();
  }

  @override
  Future<void> googleAuth() async => firebaseRemoteDataSource.googleAuth();

  @override
  Future<void> signOut() async {
    return firebaseRemoteDataSource.signOut();
  }

  @override
  Future<String> getCurrentUid() async {
    return firebaseRemoteDataSource.getCurrentUid();
  }

  @override
  Future<void> addUserGroup(UserEntity userEntity) {
    return firebaseRemoteDataSource.addUserGroup(userEntity);
  }

    @override
  Future<void> editColorCreator(UserEntity userEntity) {
    return firebaseRemoteDataSource.editColorCreator(userEntity);
  }
}
