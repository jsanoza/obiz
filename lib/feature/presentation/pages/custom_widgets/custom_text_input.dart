//Usage if normal Textfield do not supply validator
//supply controller to fetch the text
//  Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: KoalaTextFieldInputBoxx(
//     validator: null,
//     hintText: "First Name",
//     actionKeyboard: TextInputAction.done,
//     controller: _firstname,
//     readOnly: false,
//     suffixIcon: const Icon(
//          Icons.supervisor_account_rounded,
//          color: Colors.white,
//          ),
//     prefixIcon: const Icon(Icons.keyboard_hide),
//   ),
// ),

//if email supply emailValidator
//supply controller to fetch the text
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: KoalaTextFieldInputBoxx(
//     validator: emailValidator,
//     hintText: "Email",
//     actionKeyboard: TextInputAction.done,
//     controller: _email,
//     readOnly: false,
//     suffixIcon: null,
//     prefixIcon: const Icon(Icons.keyboard_hide),
//   ),
// ),

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_tooltip.dart';

class ITextFieldInputBoxx extends StatefulWidget {
  // final TextInputType textInputType;
  final String hintText;
  final TextEditingController controller;
  final TextInputAction actionKeyboard;
  final String? Function(String?)? validator;
  final String tooltipMessage;
  final bool readOnly;
  final Icon suffixIcon;

  const ITextFieldInputBoxx({
    Key? key,
    // required this.textInputType,
    required this.hintText,
    required this.tooltipMessage,
    this.readOnly = false,
    required this.controller,
    this.actionKeyboard = TextInputAction.next,
    required this.validator,
    required this.suffixIcon,
  }) : super(key: key);

  @override
  _ITextFieldInputBoxxState createState() => _ITextFieldInputBoxxState();
}

class _ITextFieldInputBoxxState extends State<ITextFieldInputBoxx> {
  double bottomPaddingToError = 12;
  bool showIcon = false;
  bool showSecondIcon = false;
  @override
  void initState() {
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
      // keyboardType: widget.textInputType,
      textInputAction: widget.actionKeyboard,
      readOnly: widget.readOnly,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        // fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        // letterSpacing: 1.2,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.validator != null && showIcon == true
            ? const ITooltip(
                message: 'Input must be an Email Address',
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              )
            : showSecondIcon == true && widget.suffixIcon != null
                ? widget.suffixIcon
                : const Icon(
                    Icons.check,
                    color: Color(0xff00c85f),
                  ),
        hintText: widget.hintText,
        enabledBorder: widget.readOnly == true
            ? showSecondIcon == false
                ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff1b476f)))
                : const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  )
            : const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
        focusedBorder: widget.readOnly == true
            ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff1b476f)))
            : widget.validator != null
                ? showSecondIcon == true
                    ? const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      )
                    : const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff00c85f)),
                      )
                : const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 25, 178, 238)),
                  ),
        // hintStyle: const TextStyle(
        //   color: Colors.black,
        //   fontSize: 14.0,
        //   fontWeight: FontWeight.w400,
        //   // fontStyle: FontStyle.normal,
        //   letterSpacing: 1.2,
        // ),
        hintStyle: GoogleFonts.firaSansCondensed(
          color: Colors.white,
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
        if (widget.validator != null) {
          var message = widget.validator!(widget.controller.text.toString());
          setState(() {
            if (message == " ") {
              showIcon = true;
            } else {
              showIcon = false;
              showSecondIcon = false;
            }
          });
        }
      },
      onEditingComplete: () {
        setState(() {});
        FocusScope.of(context).unfocus();
      },
      validator: widget.validator,
    );
  }
}

// Validator
//checks if input is an email
String? Function(String?)? emailValidator = (String? value) {
  if (!value!.contains("@") || !value.contains(".")) {
    return ' ';
  } else if (value.isEmpty) {
    return null;
  } else {
    return null;
  }
};
