import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color kprimary = Color(0xffE0232A);
const Color grey = Color(0xffC0CFDD);
const Color Secondary = Color(0xff700d2d);

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _blackPrimaryValue = 0xff455a64;

  static const MaterialColor blackPrimaryValue = const MaterialColor(
    _blackPrimaryValue,
    const <int, Color>{
      50: const Color(0xff455a64),
      100: const Color(0xffC0CFDD),
      200: const Color(0xffC0CFDD),
      300: const Color(0xffC0CFDD),
      400: const Color(0xffC0CFDD),
      500: const Color(_blackPrimaryValue),
      600: const Color(0xffC0CFDD),
      700: const Color(0xffC0CFDD),
      800: const Color(0xff700d2d),
      900: const Color(0xff700d2d),
    },
  );
}
