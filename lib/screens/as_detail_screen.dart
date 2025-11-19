import 'package:flutter/material.dart';
import 'package:project/screens/as_board_screen.dart';

class AsDetailScreen extends StatelessWidget {
  final Post post;

  const AsDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('작성자: ${post.author}'),
            Text('작성일: ${post.date.toString().substring(0, 10)}'),
            const Divider(),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}
