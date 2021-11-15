import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/domain/use_cases/add_group_uc.dart';
import 'package:sample_app_request/feature/domain/use_cases/add_new_note_uc.dart';
import 'package:sample_app_request/feature/domain/use_cases/edit_color_creator.dart';
import 'package:sample_app_request/feature/domain/use_cases/get_current_user_uc.dart';
import 'package:sample_app_request/feature/domain/use_cases/google_sign_in_usecase.dart';
import 'package:sample_app_request/feature/domain/use_cases/sign_in_uc.dart';
import 'package:sample_app_request/feature/domain/use_cases/sign_out_uc.dart';
import 'package:sample_app_request/feature/domain/use_cases/sign_up_uc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(
    this.signInUseCase,
    this.signOutUseCase,
    this.getCreateCurrentUserUseCase,
    this.signUpUseCase,
    this.googleSignInUseCase,
    this.addUserGroupUseCase,
    this.editColorCreatorUseCase,
  ) : super(UserInitial());

  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final SignUpUseCase signUpUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;
  final AddUserGroupUseCase addUserGroupUseCase;
  final EditColorCreatorUseCase editColorCreatorUseCase;

  Future submitSignIn(UserEntity userEntity) async {
    print('sign in ');
    try {
      await signInUseCase.call(userEntity);
      emit(UserSuccess());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future submitSignUp(UserEntity userEntity) async {
    print('submit');
    try {
      await signUpUseCase.call(userEntity);
      await getCreateCurrentUserUseCase.call(userEntity);
      emit(UserSuccess());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> googleAuthSubmit() async {
    emit(UserLoading());
    try {
      await googleSignInUseCase.call();
      emit(UserSuccess());
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> addUserGroup(UserEntity userEntity) async {
    try {
      await addUserGroupUseCase.call(userEntity);
    } on SocketException catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> editColorCreator(UserEntity userEntity) async {
    try {
      await editColorCreatorUseCase.call(userEntity);
    } on SocketException catch (_) {
      emit(UserFailure());
    }
  }
}
