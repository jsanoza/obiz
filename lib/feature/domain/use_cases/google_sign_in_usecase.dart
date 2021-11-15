import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';

class GoogleSignInUseCase {
  final FirebaseRepository firebaseRepository;

  GoogleSignInUseCase({required this.firebaseRepository});

  Future<void> call() {
    return firebaseRepository.googleAuth();
  }
}
