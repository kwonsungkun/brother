import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';

// 1. 최근 발송 내역 데이터 모델 추가
class NotificationHistory {
  final String target;
  final String type;
  final String message;
  final String timestamp;

  const NotificationHistory({required this.target, required this.type, required this.message, required this.timestamp});
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedTarget = '모든 세입자';
  String _selectedType = '일반 공지';
  final TextEditingController _messageController = TextEditingController();

  // 2. 최근 발송 내역 더미 데이터 생성
  final List<NotificationHistory> _recentNotifications = [
    const NotificationHistory(target: '강남 럭키빌딩 전체', type: '일반 공지', message: '10월 정기 소독 안내...', timestamp: '1일 전'),
    const NotificationHistory(target: '마포 하이츠빌 101호', type: '요금 청구', message: '7월분 관리비 미납 안내...', timestamp: '3일 전'),
    const NotificationHistory(target: '모든 세입자', type: '계약 관련', message: '전세보증보험 관련 안내문...', timestamp: '7일 전'),
  ];

  void _onItemTapped(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),
      (Route<dynamic> route) => false,
    );
  }

  // 3. 발송 완료 대화상자 함수 추가
  void _showSentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림'),
        content: const Text('발송되었습니다.'),
        actions: [
          TextButton(child: const Text('확인'), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 알림 발송', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNotificationForm(),
            const SizedBox(height: 24),
            _buildRecentHistory(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보'),
        ],
        currentIndex: 0, 
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationForm() {
    return _buildSection(
      title: '새 알림 발송',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('발송 대상', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDropdown(['모든 세입자', '특정 건물 세입자', '특정 세입자'], _selectedTarget, (val) => setState(() => _selectedTarget = val!)),
          const SizedBox(height: 16),
          const Text('알림 종류', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDropdown(['일반 공지', '요금 청구', '계약 관련'], _selectedType, (val) => setState(() => _selectedType = val!)),
          const SizedBox(height: 16),
          const Text('메시지 내용', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '알림 내용을 입력하세요...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showSentDialog, // 4. 버튼에 함수 연결
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('알림 발송', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
      ),
    );
  }

  // 5. 최근 발송 내역 UI 수정
  Widget _buildRecentHistory() {
    return _buildSection(
      title: '최근 발송 내역',
      child: _recentNotifications.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text('아직 발송된 알림이 없습니다.', style: TextStyle(color: Colors.grey)),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentNotifications.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final item = _recentNotifications[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('[${item.type}] ${item.target}'),
                  subtitle: Text(item.message, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text(item.timestamp, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                );
              },
            ),
    );
  }
}
