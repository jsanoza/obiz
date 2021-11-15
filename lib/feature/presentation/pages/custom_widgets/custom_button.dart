import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const IButtonPrimaryColor = Color.fromARGB(255, 25, 178, 238);
const IButtonTextPrimaryColor = Colors.white;

const IButtonSecondaryColor = Colors.white;
const IButtonTextSecondaryColor = Color(0xFF050E19);
const IBorderColor = Color(0xFFE3E3E3);

const IIconButtonPrimaryColor = Colors.white;
const IIconButtonTextColor = Colors.black;

const IDisabledButton = Color.fromRGBO(27, 70, 127, 0.5);
const IDisabledButtonTextColor = Colors.white;

const ITextButton = Colors.white;
const ITextButtonTextColor = Colors.black;
const ITextButtonBordersideColor = Colors.white;

/// ### USAGE

/// ```dart
/// [KoalaButton.primary(
///     text: 'PRIMARY',
///     height: 46.0,
///     width: 140.0,
///     onTap: () {}),
/// ```dart
///
///  ```dart
/// KoalaButton.secondary(
///      text: 'SECONDARY',
///      height: 46.0,
///      width: 140.0,
///     onTap: () {}),
/// ```dart

class IButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final Color? borderSide;
  final VoidCallback? onTap;
  final String? assetPath;
  final Color textColor;
  final Color backgroundColor;
  final bool isDisabled;
  final bool isLoading;
  final bool hasIcon;
  final bool isTextbutton;

  const IButton({required this.text, this.height, this.width, this.borderSide, required this.onTap, this.assetPath, required this.textColor, required this.backgroundColor, required this.isDisabled, required this.isLoading, required this.hasIcon, required this.isTextbutton, Key? key})
      : super(key: key);

  const IButton.primary({required this.text, this.height, this.width, required this.onTap, Key? key})
      : backgroundColor = IButtonPrimaryColor,
        textColor = IButtonTextPrimaryColor,
        isDisabled = false,
        isLoading = false,
        hasIcon = false,
        assetPath = null,
        isTextbutton = false,
        borderSide = null,
        super(key: key);

  const IButton.secondary({required this.text, this.height, this.width, required this.onTap, Key? key})
      : backgroundColor = IButtonSecondaryColor,
        textColor = IButtonTextSecondaryColor,
        isDisabled = false,
        isLoading = false,
        hasIcon = false,
        assetPath = null,
        isTextbutton = false,
        borderSide = null,
        super(key: key);

  const IButton.disabled({this.height, this.width, Key? key})
      : text = '',
        backgroundColor = IDisabledButton,
        textColor = IDisabledButtonTextColor,
        isDisabled = true,
        isLoading = false,
        hasIcon = false,
        assetPath = null,
        isTextbutton = false,
        onTap = null,
        borderSide = null,
        super(key: key);

  const IButton.loading({this.height, this.width, Key? key})
      : text = '',
        backgroundColor = IButtonPrimaryColor,
        textColor = Colors.white,
        isDisabled = true,
        isLoading = true,
        hasIcon = false,
        assetPath = null,
        isTextbutton = false,
        onTap = null,
        borderSide = null,
        super(key: key);

  const IButton.withIcon({required this.text, this.height, this.width, required this.onTap, required this.assetPath, Key? key})
      : backgroundColor = IIconButtonPrimaryColor,
        textColor = IIconButtonTextColor,
        isDisabled = false,
        isLoading = false,
        hasIcon = true,
        isTextbutton = false,
        borderSide = null,
        super(key: key);

  const IButton.textButton({required this.text, this.height, this.width, required this.onTap, Key? key})
      : backgroundColor = ITextButton,
        textColor = ITextButtonTextColor,
        borderSide = ITextButtonBordersideColor,
        isDisabled = false,
        isLoading = false,
        assetPath = null,
        hasIcon = false,
        isTextbutton = true,
        super(key: key);

  //* remove splash if isDisabled
  @override
  Widget build(BuildContext context) {
    return isTextbutton
        ? _ITextButton(
            text: text,
            textColor: textColor,
            onTap: onTap ?? () {},
            height: height,
            width: width,
          )
        : _IElevatedButton(
            isLoading: isLoading,
            text: text,
            textColor: textColor,
            backgroundColor: backgroundColor,
            onTap: onTap,
            hasIcon: hasIcon,
            assetPath: assetPath,
            borderSide: borderSide,
            height: height,
            width: width,
          );
  }
}

class _ButtonText extends StatelessWidget {
  final String text;
  final Color textColor;

  const _ButtonText({required this.text, required this.textColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.firaSansCondensed(
        textStyle: Theme.of(context).textTheme.headline4,
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w300,
        // fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 1.0,
      ),
    );
  }
}

class _IElevatedButton extends StatelessWidget {
  final bool isLoading;
  final String? text;
  final Color textColor;
  final double? height;
  final double? width;
  final Color backgroundColor;
  final Color? borderSide;
  final VoidCallback? onTap;
  final bool hasIcon;
  final String? assetPath;

  const _IElevatedButton({required this.isLoading, required this.text, required this.textColor, required this.height, required this.width, required this.backgroundColor, required this.borderSide, required this.onTap, required this.hasIcon, required this.assetPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(23.0, 14, 23.0, 14),
          fixedSize: Size(width ?? 340.0, height ?? 50.0),
          primary: backgroundColor,
          side: BorderSide(width: 1.0, color: borderSide ?? Colors.transparent),
        ),
        onPressed: onTap ?? () {},
        child: Center(
            child: hasIcon
                ? _IButtonIcon(
                    text: text ?? '',
                    assetPath: assetPath ?? '',
                    textColor: textColor,
                  )
                : isLoading
                    ? const _Loading()
                    : _ButtonText(text: text ?? '', textColor: textColor)));
  }
}

class _IButtonIcon extends StatelessWidget {
  final String text;
  final String assetPath;
  final Color textColor;

  const _IButtonIcon({required this.text, required this.assetPath, required this.textColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Image.asset(assetPath),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(text, maxLines: 1, softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(color: textColor, fontFamily: 'Gill Sans', fontWeight: FontWeight.w400, fontSize: 13.0)),
          ],
        ),
      ],
    );
  }
}

class _ITextButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final VoidCallback onTap;
  final Color textColor;

  const _ITextButton({required this.text, required this.textColor, required this.height, required this.width, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50.0,
      width: width ?? 340.0,
      child: TextButton(
          onPressed: onTap,
          child: Text(
            text,
            // style: TextStyle(
            //   color: textColor,
            //   fontFamily: 'Gill Sans',
            //   fontWeight: FontWeight.w400,
            //   fontSize: 15.0,
            // ),
            style: GoogleFonts.firaSansCondensed(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 14,
              fontWeight: FontWeight.w200,
              // fontStyle: FontStyle.italic,
            ),
          )),
    );
  }
}
