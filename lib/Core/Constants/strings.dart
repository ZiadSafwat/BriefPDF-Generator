import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color container = const Color(0xfffff8f7).withOpacity(.5);
Color fontColor =  Colors.white;

class AppString{
  String url ='https://waves.pockethost.io/user-profile/3b5wmxh6tierl5h';
}

Widget customContainer(Widget child) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 30, sigmaX: 30),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x66d4e6e6), // Pre-applied opacity (0x66 = ~40%)
              Color(0x4D8ea9e5), // Pre-applied opacity (0x4D = ~30%)
            ],
          ),
          border: Border.all(width: 2, color: Colors.white.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: child,
      ),
    ),
  );
}


List attributes = [
  "اسم العميل",
  "اسم المؤسسة",
  "رقم الهاتف",
  'اسم المشروع',
  'وصف المشروع',
  'نوع المشروع',
  'الالوان المفضلة',
  'نوع اللوجو',
  'isKidsSelected',
  'isYouthSelected',
  'isWomenSelected',
  'isGroupSelected',
  'isIconLogoSelected',
  'isTextLogoSelected',
  'isLetterLogoSelected',
  'isMixedLogoSelected',
  'isCartoonLogoSelected',
  'isArabicLogoSelected',
];
double budget = 10;
