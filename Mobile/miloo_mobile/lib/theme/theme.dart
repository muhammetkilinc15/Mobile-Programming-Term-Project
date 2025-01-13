import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';

ThemeData theme() => ThemeData(
      appBarTheme: appBarTheme(),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Plus Jakarta",
      textTheme: textTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      inputDecorationTheme: inputDecationTheme(),
    );

InputDecorationTheme inputDecationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );

  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding:
        const EdgeInsetsDirectional.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
    hintStyle: const TextStyle(color: kTextColor),
    labelStyle: const TextStyle(color: kTextColor),
  );
}

TextTheme textTheme() => const TextTheme(
      bodyMedium: TextStyle(color: kTextColor),
      bodySmall: TextStyle(color: kTextColor),
      bodyLarge: TextStyle(color: kTextColor),
    );

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 18,
    ),
    iconTheme: IconThemeData(color: Colors.black),
  );
}
