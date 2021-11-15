import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';

class GetCurrentIdUseCase {
  final FirebaseRepository firebaseRepository;

  GetCurrentIdUseCase(this.firebaseRepository);

  Future<String> call() async {
    return firebaseRepository.getCurrentUid();
  }
}
