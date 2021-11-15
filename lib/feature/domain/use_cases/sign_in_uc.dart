import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';

class SignInUseCase {
  final FirebaseRepository firebaseRepository;

  SignInUseCase(this.firebaseRepository);

  Future<void> call(UserEntity userEntity) async {
    return firebaseRepository.signIn(userEntity);
  }
}
