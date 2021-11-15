import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';

class GetCreateCurrentUserUseCase {
  final FirebaseRepository firebaseRepository;

  GetCreateCurrentUserUseCase(this.firebaseRepository);

  Future<void> call(UserEntity userEntity) async {
    return firebaseRepository.getCreateCurrentUser(userEntity);
  }
}
