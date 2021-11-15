import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_app_request/app_constants.dart';
import 'package:sample_app_request/common.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:sample_app_request/feature/presentation/cubit/user/user_cubit.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_button.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_password_input.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widget_extensions.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 25, 178, 238), Color.fromARGB(255, 21, 236, 229)],
        )),
        child: BlocConsumer<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(builder: (c, authState) {
                if (authState is Authenticated) {
                  return HomePage(uid: authState.uid);
                } else
                  return _bodyWidget();
              });
            }
            return _bodyWidget();
          },
          listener: (context, userState) {
            if (userState is UserSuccess) {
              print('user su');
              BlocProvider.of<AuthCubit>(context).loggedIn();
            } else if (userState is UserFailure) {
              snackBarError('invalid mail', _globalKey);
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
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 25),
                  child: SizedBox(
                    width: 150,
                    child: Image.asset("assets/logo3.png"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 40),
                      child: Text(
                        'Welcome!',
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
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset('assets/logo4.png'),
                      iconSize: 50,
                      onPressed: () async {
                        await SharedPreferences.getInstance().then((SharedPreferences sp) {
                          sp.remove('groupName');
                        }).then((value) {
                          BlocProvider.of<UserCubit>(context).googleAuthSubmit();
                        });
                      },
                    )
                  ],
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

  // void _signIn() {
  //   if (_passwordController.text.isNotEmpty && _emailController.text.isNotEmpty) {
  //     BlocProvider.of<UserCubit>(context).submitSignIn(UserEntity(email: _emailController.text, password: _passwordController.text));
  //   } else {
  //     BC(context).makeSnackbar('Enter Valid Credentials');
  //   }
  // }
}
