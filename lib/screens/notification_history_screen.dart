import 'package:flutter/material.dart';

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({super.key});

  final List<String> _notifications = const [
    '201호 세대에서 새로운 A/S를 요청했습니다.',
    '관리비 납부 마감일이 3일 남았습니다.',
    '커뮤니티에 새로운 공지사항이 등록되었습니다.',
    '9월분 정기 소독이 완료되었습니다.',
    '[공지] 10월 5일(토) 엘리베이터 정기 점검 안내',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 내역'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.separated(
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications_none_outlined),
            title: Text(_notifications[index]),
            subtitle: Text('${index + 1}일 전'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
