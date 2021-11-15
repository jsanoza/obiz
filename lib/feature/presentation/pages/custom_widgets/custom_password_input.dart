//Usage
//supply controller to fetch the text
// KoalaPasswordInputBoxx(
//   validator: passwordValidator,
//   hintText: "Password",
//   obscureText: true,
//   actionKeyboard: TextInputAction.done,
//   controller: _password,
//   readOnly: false,
//   prefixIcon: const Icon(Icons.keyboard_hide),
// ),

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IPasswordInputBoxx extends StatefulWidget {
  // final TextInputType textInputType;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputAction actionKeyboard;
  final String? Function(String?)? validator;
  final bool readOnly;

  const IPasswordInputBoxx({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.actionKeyboard = TextInputAction.next,
    required this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _IPasswordInputBoxxState createState() => _IPasswordInputBoxxState();
}

class _IPasswordInputBoxxState extends State<IPasswordInputBoxx> {
  double bottomPaddingToError = 12;
  bool showIcon = false;
  bool showSecondIcon = false;
  bool _isObscure = true;
  @override
  void initState() {
    // TODO: implement initState
    _isObscure = widget.obscureText;
    if (widget.controller.text.isEmpty) {
      showSecondIcon = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.blue,
      obscureText: _isObscure,
      // keyboardType: widget.textInputType,
      textInputAction: widget.actionKeyboard,
      readOnly: widget.readOnly,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        letterSpacing: 1.2,
      ),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          constraints: const BoxConstraints(),
          iconSize: 20,
          icon: Icon(_isObscure == true ? Icons.visibility_off : Icons.visibility),
          color: Colors.white,
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        hintText: widget.hintText,
        enabledBorder: widget.readOnly == true
            ? showSecondIcon == false
                ? const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))
                : const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff7791B3)),
                  )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
        focusedBorder: widget.readOnly == true
            ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff00c85f)))
            : widget.validator != null
                ? showSecondIcon == true
                    ? const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      )
                    : const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff00c85f)),
                      )
                : const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff1b476f)),
                  ),
        hintStyle: GoogleFonts.firaSansCondensed(
          color: Colors.black,
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 14,
          fontWeight: FontWeight.w200,
          // fontStyle: FontStyle.italic,
        ),
        contentPadding: EdgeInsets.only(top: 12, bottom: bottomPaddingToError, left: 8.0, right: 8.0),
        isDense: true,
        errorStyle: const TextStyle(
          color: Colors.red,
          height: 0,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      controller: widget.controller,
      onChanged: (value) {
        var message = widget.validator!(widget.controller.text.toString());
        setState(() {
          if (message == " ") {
            showIcon = true;
          } else {
            showIcon = false;
            showSecondIcon = false;
          }
        });
      },
      onEditingComplete: () {
        setState(() {});
        FocusScope.of(context).unfocus();
      },
      validator: widget.validator,
    );
  }
}

//Validator
// Minimum 1 Upper case
// Minimum 1 lowercase
// Minimum 1 Numeric Number
// Minimum 1 Special Character
// Common Allow Character ( ! @ # $ & * ~ )
// ignore: prefer_function_declarations_over_variables
String? Function(String?)? passwordValidator = (String? value) {
  bool passValid = RegExp("^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*").hasMatch(value!);
  if (value.isEmpty || !passValid) {
    return " ";
  } else {
    return null;
  }
};
