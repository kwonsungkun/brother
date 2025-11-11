import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart'; // 1. 시작 화면 import 변경

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      home: const RoleSelectionScreen(), // 2. 시작 화면을 RoleSelectionScreen으로 변경
      debugShowCheckedModeBanner: false,
    );
  }
}
