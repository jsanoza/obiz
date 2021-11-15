import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<bool> isSignedIn();

  Future<void> signIn(UserEntity userEntity);

  Future<void> signUp(UserEntity userEntity);

  Future<void> signOut();

  Future<String> getCurrentUid();

  Future<void> getCreateCurrentUser(UserEntity userEntity);

  Future<void> addNewNote(NoteEntity noteEntity);

  Future<void> updateNote(NoteEntity noteEntity);

  Future<void> deleteNewNote(NoteEntity noteEntity);

  Future<void> googleAuth();

  Stream<List<NoteEntity?>> getNotes(String uid, String group);

  Future<void> addUserGroup(UserEntity userEntity);
  Future<void> editColorCreator(UserEntity userEntity);
}
