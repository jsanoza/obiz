import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';

class GetNotesUseCase {
  final FirebaseRepository firebaseRepository;

  GetNotesUseCase(this.firebaseRepository);

  Stream<List<NoteEntity?>> call(String uid, String group) {
    return firebaseRepository.getNotes(uid, group);
  }
}
