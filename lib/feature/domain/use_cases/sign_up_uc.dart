import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';

class SignUpUseCase {
  final FirebaseRepository firebaseRepository;

  SignUpUseCase(this.firebaseRepository);

  Future<void> call(UserEntity userEntity) async {
    return firebaseRepository.signUp(userEntity);
  }
}
