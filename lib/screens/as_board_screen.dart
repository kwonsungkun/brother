import 'package:flutter/material.dart';
import 'package:project/screens/as_write_screen.dart';
import 'package:project/screens/as_detail_screen.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime date;
  int views;
  final int comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    this.views = 0,
    this.comments = 0,
  });
}

class AsBoardScreen extends StatefulWidget {
  const AsBoardScreen({super.key});

  @override
  State<AsBoardScreen> createState() => _AsBoardScreenState();
}

class _AsBoardScreenState extends State<AsBoardScreen> {
  final List<Post> _posts = [
    Post(id: 1, title: '첫 번째 게시물', content: '내용입니다.', author: '김철수', date: DateTime.now().subtract(const Duration(days: 1)), views: 15, comments: 5),
    Post(id: 2, title: '두 번째 게시물', content: '내용입니다.2', author: '이영희', date: DateTime.now().subtract(const Duration(hours: 5)), views: 23, comments: 12),
    Post(id: 3, title: '세 번째 게시물', content: '내용입니다.3', author: '박지민', date: DateTime.now().subtract(const Duration(minutes: 30)), views: 8, comments: 2),
  ];

  late List<Post> _filteredPosts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPosts = _posts;
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPosts = _posts.where((post) {
        return post.title.toLowerCase().contains(query) || 
               post.author.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _startSearch() {
    setState(() {
    });
  }

  void _stopSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A/S 게시판'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _startSearch),
        ],
      ),
      body: ListView.separated(
        itemCount: _filteredPosts.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final post = _filteredPosts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text('${post.author} | ${post.date.toString().substring(0, 10)}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('조회 ${post.views}'),
                Text('댓글 ${post.comments}'),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AsDetailScreen(post: post),
                ),
              );

              if (result == true) {
                setState(() {
                  post.views++;
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AsWriteScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
