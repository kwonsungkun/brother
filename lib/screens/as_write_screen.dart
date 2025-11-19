import 'package:flutter/material.dart';

class AsWriteScreen extends StatelessWidget {
  const AsWriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글쓰기'),
      ),
      body: const Center(
        child: Text('A/S 게시판 글쓰기 화면'),
      ),
    );
  }
}
