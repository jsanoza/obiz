import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';

class UpdateNoteUseCase {
  final FirebaseRepository firebaseRepository;

  UpdateNoteUseCase(this.firebaseRepository);

  Future<void> call(NoteEntity noteEntity) async {
    return firebaseRepository.updateNote(noteEntity);
  }
}
