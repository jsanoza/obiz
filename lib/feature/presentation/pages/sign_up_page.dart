import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_app_request/app_constants.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:sample_app_request/feature/presentation/cubit/user/user_cubit.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_button.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_password_input.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_text_input.dart';

import '../../../common.dart';
import '../../../widget_extensions.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 25, 178, 238), Color.fromARGB(255, 21, 236, 229)],
        )),
        child: BlocConsumer<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(builder: (c, authState) {
                if (authState is Authenticated) {
                  return HomePage(uid: authState.uid);
                } else {
                  return _bodyWidget();
                }
              });
            }
            return _bodyWidget();
          },
          listener: (context, state) {
            if (state is UserSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            } else if (state is UserFailure) {
              snackBarError('Invalid mail', _globalKey);
            }
          },
        ),
      ),
    );
  }

  _bodyWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.4), borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 40),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.firaSansCondensed(
                          color: Colors.black45,
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 70,
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: ITextFieldInputBoxx(
                      hintText: "Username",
                      tooltipMessage: "Enter Username",
                      controller: _usernameController,
                      validator: null,
                      suffixIcon: const Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: ITextFieldInputBoxx(
                      hintText: "Email Address",
                      tooltipMessage: "Invalid Email",
                      controller: _emailController,
                      validator: emailValidator,
                      suffixIcon: const Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: IPasswordInputBoxx(
                      hintText: "Password",
                      controller: _passwordController,
                      obscureText: true,
                      validator: passwordValidator,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 0),
                  child: IButton.primary(
                    text: 'REGISTER',
                    height: 46.0,
                    width: MediaQuery.of(context).size.width,
                    onTap: () {
                      // _signUp();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.firaSansCondensed(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, PageConst.signInPage, (route) => false);
                          },
                          child: Text(
                            "Login now",
                            style: GoogleFonts.firaSansCondensed(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // void _signUp() {
  //   if (_passwordController.text.isNotEmpty && _usernameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
  //     BlocProvider.of<UserCubit>(context).submitSignUp(UserEntity(email: _emailController.text, password: _passwordController.text)).then((value) => print('then: ${value}')).onError((error, stackTrace) => print('err: ${error}'));
  //   } else {
  //     BC(context).makeSnackbar('Enter Valid Credentials');
  //   }
  // }
}
