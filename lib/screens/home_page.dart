import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'as_board_screen.dart';
import 'notification_history_screen.dart'; // 알림 내역 화면 import

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  bool _hasNewNotification = true; // 1. 새로운 알림 유무 상태 변수

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const Center(child: Text('캐쉬 페이지')),
    const Center(child: Text('상품 페이지')),
    const Center(child: Text('커뮤니티 게시판')), // 1. 커뮤니티 탭 연결 해제
    const Center(child: Text('내집홍보 페이지')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationHistoryScreen()),
    );
    setState(() {
      _hasNewNotification = false;
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('언어 선택'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: const Text('한국어'), onTap: () => Navigator.of(context).pop()),
                ListTile(title: const Text('영어'), onTap: () => Navigator.of(context).pop()),
                ListTile(title: const Text('중국어'), onTap: () => Navigator.of(context).pop()),
                ListTile(title: const Text('베트남어'), onTap: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), 
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined),
                onPressed: _navigateToNotifications,
                tooltip: '알림',
              ),
              if (_hasNewNotification)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                  ),
                )
            ],
          ),
          IconButton(icon: const Icon(Icons.language), onPressed: _showLanguageDialog, tooltip: '언어 변경'),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(onPressed: () {}, child: const Icon(Icons.chat_bubble_outline), tooltip: '챗봇',)
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
