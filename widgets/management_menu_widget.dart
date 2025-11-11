import 'package:flutter/material.dart';
import '../screens/as_board_screen.dart';
import '../screens/empty_room_list_screen.dart';
import '../screens/asset_status_screen.dart'; // 1. 새로 만든 화면 import
import '../screens/unpaid_list_screen.dart';
import '../screens/notification_screen.dart';

class ManagementMenuWidget extends StatelessWidget {
  const ManagementMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('관리 메뉴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 2. '장부관리' 목적지를 AssetStatusScreen으로 변경
              _buildMenuItem(Icons.book, '장부관리', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssetStatusScreen()),
                );
              }),
              _buildMenuItem(Icons.home_work, '공실관리', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmptyRoomListScreen()),
                );
              }),
              _buildMenuItem(Icons.receipt_long, '미납관리', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UnpaidListScreen()),
                );
              }),
              _buildMenuItem(Icons.support_agent, 'A/S', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ASBoardScreen()),
                );
              }),
              _buildMenuItem(Icons.campaign, '알림', () { // 아이콘 변경
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
