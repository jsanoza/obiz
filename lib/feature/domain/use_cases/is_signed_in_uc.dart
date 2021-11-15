import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';

class IsSignedInUseCase {
  final FirebaseRepository firebaseRepository;

  IsSignedInUseCase(this.firebaseRepository);

  Future<bool> call() async {
    return firebaseRepository.isSignedIn();
  }
}
