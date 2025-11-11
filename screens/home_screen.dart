import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/management_menu_widget.dart';
import 'billing_details_screen.dart';
import 'job_list_screen.dart';
import 'unpaid_list_screen.dart';
import 'empty_room_list_screen.dart';
import 'asset_status_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _propertyData = [
    {
      'address': '전체 자산 현황',
      'totalRent': '21,770,000',
      'cashBalance': '36,440,000',
      'expiringUnits': ['404호', '301호', '202호', '102호'],
      'delinquentUnits': [
        {'room': '201호', 'days': '7일', 'amount': '450,000'},
        {'room': '303호', 'days': '14일', 'amount': '470,000'},
        {'room': '708호', 'days': '46일', 'amount': '500,000'},
        {'room': '302호', 'days': '30일', 'amount': '1,200,000'},
      ]
    },
    {
      'address': '부산광역시 서구 아미동2가 19-8(골든파크빌)',
      'totalRent': '9,270,000',
      'cashBalance': '11,440,000',
      'expiringUnits': ['404호', '301호', '202호'],
      'delinquentUnits': [
        {'room': '201호', 'days': '7일', 'amount': '450,000'},
        {'room': '303호', 'days': '14일', 'amount': '470,000'},
        {'room': '708호', 'days': '46일', 'amount': '500,000'},
      ]
    },
    {
      'address': '서울시 강남구 테헤란로 123(강남 럭키빌딩)',
      'totalRent': '12,500,000',
      'cashBalance': '25,000,000',
      'expiringUnits': ['102호'],
      'delinquentUnits': [
        {'room': '302호', 'days': '30일', 'amount': '1,200,000'},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openKakaoMap() async { /* ... */ }
  Future<void> _openSGIUrl() async { /* ... */ }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildMonthlySummary(),
          ),
          const SizedBox(height: 24),
          const ManagementMenuWidget(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildInfoCard(title: '내 건물 수익률 얼마일까?', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BillingDetailsScreen()))),
                const SizedBox(height: 16),
                _buildInfoCard(title: '주변 부동산', onTap: _openKakaoMap),
                const SizedBox(height: 16),
                _buildInfoCard(title: '일자리 정보', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const JobListScreen()))),
                const SizedBox(height: 16),
                _buildInfoCard(title: '간편 보증보험가입', isSpecial: true, onTap: _openSGIUrl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary() {
    return Column(
      children: [
        SizedBox(
          height: 330,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _propertyData.length,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return _buildPropertyCard(_propertyData[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_propertyData.length, (index) {
            return Container(
              width: 8.0, height: 8.0, margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == index ? Colors.deepPurple : Colors.grey.shade300),
            );
          }),
        )
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> data) {
    final bool isOverall = data['address'] == '전체 자산 현황';
    final expiringUnits = (data['expiringUnits'] as List<String>);
    final delinquentUnits = (data['delinquentUnits'] as List<Map<String, String>>);

    return Card(
      elevation: 4,
      color: Colors.deepPurple.shade400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. InkWell 위치 변경
            Text(data['address'], style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AssetStatusScreen())),
              child: Text.rich(TextSpan(style: const TextStyle(color: Colors.white, fontSize: 22), children: [const TextSpan(text: '월세 총액 '), TextSpan(text: data['totalRent'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.white)), const TextSpan(text: '원')])),
            ),
            const SizedBox(height: 8),
            Row(children: [Text('캐쉬 보유액 ${data['cashBalance']}', style: TextStyle(color: Colors.white70)), const SizedBox(width: 8), TextButton(onPressed: () {}, style: TextButton.styleFrom(backgroundColor: Colors.purple.shade300, foregroundColor: Colors.white, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), minimumSize: const Size(0, 28), tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Text('이체', style: TextStyle(fontSize: 12)))]),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isOverall || expiringUnits.isNotEmpty)
                  Expanded(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EmptyRoomListScreen())), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('만기 예정세대', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), ...(isOverall ? expiringUnits.take(3) : expiringUnits).map((unit) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(unit, style: const TextStyle(fontSize: 16, color: Colors.white))))]))),
                if (!isOverall || delinquentUnits.isNotEmpty)
                  Expanded(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UnpaidListScreen())), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('미납자 호실', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 12), ...(isOverall ? delinquentUnits.take(3) : delinquentUnits).map((unit) => Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text('${unit['room']} ${unit['days']} 연체 ${unit['amount']}', style: const TextStyle(color: Colors.white, fontSize: 16))))]))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, String? content, bool isSpecial = false, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      color: isSpecial ? Colors.yellow[100] : Colors.white,
      child: ListTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), trailing: content != null ? Text(content, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)) : const Icon(Icons.arrow_forward_ios), onTap: onTap),
    );
  }
}
