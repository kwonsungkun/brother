import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/management_menu_widget.dart';
import 'billing_details_screen.dart';
import 'job_list_screen.dart';

class MonthlySummaryData {
  final String unpaid;
  final String paid;
  final String deposit;

  const MonthlySummaryData({required this.unpaid, required this.paid, required this.deposit});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentMonth = 10;

  final Map<int, MonthlySummaryData> _monthlyData = {
    8: const MonthlySummaryData(unpaid: '1,500,000원', paid: '5,500,000원', deposit: '42,000,000원'),
    9: const MonthlySummaryData(unpaid: '750,000원', paid: '6,250,000원', deposit: '42,000,000원'),
    10: const MonthlySummaryData(unpaid: '2,885,229원', paid: '3,903,966원', deposit: '42,000,000원'),
  };

  Future<void> _openKakaoMap() async {
    final Uri kakaoMapAppUri = Uri.parse('kakaomap://search?q=부동산');
    final Uri kakaoMapWebUri = Uri.parse('https://map.kakao.com/?q=부동산');

    if (await canLaunchUrl(kakaoMapAppUri)) {
      await launchUrl(kakaoMapAppUri);
    } else {
      await launchUrl(kakaoMapWebUri);
    }
  }

  Future<void> _openSGIUrl() async {
    final Uri sgiUrl = Uri.parse('https://www.sgic.co.kr/biz/ccp/index.html?p=CCPSGN020201F01&t=2');
    if (await canLaunchUrl(sgiUrl)) {
      await launchUrl(sgiUrl, mode: LaunchMode.externalApplication);
    }
  }

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
                _buildInfoCard(
                  title: '내 건물 수익률 얼마일까?',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BillingDetailsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildInfoCard(title: '주변 부동산', onTap: _openKakaoMap),
                const SizedBox(height: 16),
                _buildInfoCard(
                  title: '일자리 정보',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JobListScreen()),
                    );
                  },
                ),
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
    final summary = _monthlyData[_currentMonth] ?? const MonthlySummaryData(unpaid: '0원', paid: '0원', deposit: '0원');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(icon: const Icon(Icons.arrow_left), onPressed: () => setState(() => _currentMonth = (_currentMonth - 1) < 1 ? 12 : _currentMonth - 1)),
            Text('$_currentMonth월', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.arrow_right), onPressed: () => setState(() => _currentMonth = (_currentMonth + 1) > 12 ? 1 : _currentMonth + 1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [const Text('보증금', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(width: 8), Text(summary.deposit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black))]),
                const SizedBox(height: 8),
                Row(children: [const Text('납입금', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(width: 8), Text(summary.paid, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green))]),
                const SizedBox(height: 8),
                Row(children: [const Text('미납금', style: TextStyle(color: Colors.grey, fontSize: 16)), SizedBox(width: 8), Text(summary.unpaid, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red))]),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BillingDetailsScreen()), 
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('분석'),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, String? content, bool isSpecial = false, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      color: isSpecial ? Colors.yellow[100] : Colors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: content != null
            ? Text(content, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue))
            : const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
