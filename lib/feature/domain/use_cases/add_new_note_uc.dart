import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';

class AddNewNoteUseCase {
  final FirebaseRepository firebaseRepository;

  AddNewNoteUseCase(this.firebaseRepository);

  Future<void> call(NoteEntity noteEntity) async {
    return firebaseRepository.addNewNote(noteEntity);
  }
}
