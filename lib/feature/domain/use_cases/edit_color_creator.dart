import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';

class EditColorCreatorUseCase {
  final FirebaseRepository firebaseRepository;

  EditColorCreatorUseCase(this.firebaseRepository);

  Future<void> call(UserEntity userEntity) async {
    return firebaseRepository.editColorCreator(userEntity);
  }
}
