import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';

class DetailItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final int amount;
  final Color color;

  DetailItem({required this.icon, required this.title, required this.subtitle, required this.amount, required this.color});
}

class BillingDetailsScreen extends StatefulWidget {
  const BillingDetailsScreen({super.key});

  @override
  State<BillingDetailsScreen> createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> with TickerProviderStateMixin {
  int _currentMonth = 11;
  int _currentYear = 2025;
  final List<bool> _periodSelection = [true, false, false];

  late TabController _detailsTabController;

  final Map<int, Map<String, int>> _revenueData = {
    11: {
      "보증금": 100000000,
      "임대료": 25000000,
      "고정 관리비": 4300000,
      "변동 관리비": 1200000,
      "미납금": -750000,
    },
    10: {
      "보증금": 50000000,
      "임대료": 24000000,
      "고정 관리비": 4200000,
      "변동 관리비": 1150000,
      "미납금": -1500000,
    },
  };

  final List<DetailItem> _depositDetails = [
    DetailItem(icon: Icons.business, title: 'A 오피스텔', subtitle: '서울시 강남구 역삼동', amount: 40000000, color: Colors.blue.shade700),
    DetailItem(icon: Icons.store, title: 'B 상가', subtitle: '경기도 성남시 분당구', amount: 35000000, color: Colors.green.shade700),
    DetailItem(icon: Icons.home_work, title: 'C 아파트', subtitle: '서울시 마포구 공덕동', amount: 25000000, color: Colors.purple.shade700),
  ];

  final List<DetailItem> _rentDetails = [
    DetailItem(icon: Icons.business, title: 'A 오피스텔', subtitle: '15개 호실', amount: 18000000, color: Colors.red.shade700),
    DetailItem(icon: Icons.store, title: 'B 상가', subtitle: '3개 호실', amount: 5000000, color: Colors.red.shade700),
    DetailItem(icon: Icons.home_work, title: 'C 아파트', subtitle: '2개 호실', amount: 2000000, color: Colors.red.shade700),
  ];

  final List<DetailItem> _fixedFeeDetails = [
    DetailItem(icon: Icons.security, title: '보안/경비', subtitle: '캡스', amount: 1800000, color: Colors.blue.shade700),
    DetailItem(icon: Icons.cleaning_services, title: '청소/미화', subtitle: '클린데이', amount: 1500000, color: Colors.blue.shade700),
    DetailItem(icon: Icons.elevator, title: '승강기 유지보수', subtitle: '오티스', amount: 1000000, color: Colors.blue.shade700),
  ];

  final List<DetailItem> _variableFeeDetails = [
    DetailItem(icon: Icons.electrical_services, title: '공용 전기요금', subtitle: '한국전력공사', amount: 750000, color: Colors.cyan.shade700),
    DetailItem(icon: Icons.water_drop, title: '공용 수도요금', subtitle: '지역 상수도사업본부', amount: 450000, color: Colors.cyan.shade700),
  ];

  final List<DetailItem> _unpaidDetails = [
    DetailItem(icon: Icons.person, title: '201호 이영희', subtitle: '월세 미납 (1개월)', amount: -750000, color: Colors.orange.shade700),
  ];

  @override
  void initState() {
    super.initState();
    _detailsTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _detailsTabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),
      (Route<dynamic> route) => false,
    );
  }

  String _formatCurrency(num amount) {
    if (amount == 0) return '0원';
    return '${amount.abs().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원';
  }

  Widget _buildPeriodButton(String text, int index) {
    bool isSelected = _periodSelection[index];
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: isSelected ? Colors.grey[200] : Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
      onPressed: () => setState(() {
        for (int i = 0; i < _periodSelection.length; i++) _periodSelection[i] = i == index;
      }),
      child: Text(text, style: TextStyle(color: isSelected ? Colors.black : Colors.grey[600], fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(children: [_buildPeriodButton('월', 0), _buildPeriodButton('년', 1), _buildPeriodButton('전체', 2)]);
  }

  // 1. 화면 흔들림 문제 해결
  Widget _buildTimeNavigation() {
    if (_periodSelection[0]) { // '월' 선택 시
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(icon: const Icon(Icons.arrow_left), onPressed: () => setState(() => _currentMonth = (_currentMonth - 1) < 1 ? 12 : _currentMonth - 1)),
          Text('$_currentMonth월', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.arrow_right), onPressed: () => setState(() => _currentMonth = (_currentMonth + 1) > 12 ? 1 : _currentMonth + 1)),
        ],
      );
    } else if (_periodSelection[1]) { // '년' 선택 시
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(icon: const Icon(Icons.arrow_left), onPressed: () => setState(() => _currentYear--)),
          Text('$_currentYear년', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.arrow_right), onPressed: () => setState(() => _currentYear++)),
        ],
      );
    } else { // '전체' 선택 시
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Opacity(opacity: 0.0, child: IconButton(icon: const Icon(Icons.arrow_left), onPressed: null)),
          const Text('22.1.6 ~ 25.11.4', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      );
    }
  }

  Widget _buildProfitRow(String title, String amount, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)), Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor ?? Colors.black))]),
    );
  }

  Widget _buildDetailList(String sectionTitle, List<DetailItem> items) {
    final totalAmount = items.fold(0, (sum, item) => sum + item.amount);

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('총 $sectionTitle (전체)', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(_formatCurrency(totalAmount), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final item = items[index];
              final ratio = totalAmount != 0 ? (item.amount / totalAmount * 100).abs().toStringAsFixed(0) : '0';
              return Row(
                children: [
                  SizedBox(width: 40, height: 40, child: Icon(item.icon, color: item.color, size: 32)),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(item.subtitle, style: TextStyle(color: Colors.grey[600]))])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(_formatCurrency(item.amount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('비중 $ratio%', style: TextStyle(color: Colors.grey[600]))]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueDetailsSection() {
    return Column(
      children: [
        TabBar(
          controller: _detailsTabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
          indicatorColor: Colors.black,
          isScrollable: false,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [Tab(text: '보증금'), Tab(text: '임대료'), Tab(text: '고정 관리비'), Tab(text: '변동 관리비'), Tab(text: '미납금')],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _detailsTabController,
            children: [
              _buildDetailList('보증금', _depositDetails),
              _buildDetailList('임대료', _rentDetails),
              _buildDetailList('고정 관리비', _fixedFeeDetails),
              _buildDetailList('변동 관리비', _variableFeeDetails),
              _buildDetailList('미납금', _unpaidDetails),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _revenueData[_currentMonth] ?? {"보증금": 0, "임대료": 0, "고정 관리비": 0, "변동 관리비": 0, "미납금": 0};
    final realizedProfit = (currentData['임대료'] ?? 0) - (currentData['고정 관리비'] ?? 0) - (currentData['변동 관리비'] ?? 0);

    Color profitColor = Colors.black87;
    String profitPrefix = '';
    if (realizedProfit > 0) { profitColor = Colors.red; profitPrefix = '+'; } else if (realizedProfit < 0) { profitColor = Colors.blue; }

    return Scaffold(
      appBar: AppBar(title: const Text('수익률 분석'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 32),
              _buildTimeNavigation(),
              const SizedBox(height: 16),
              Text(profitPrefix + _formatCurrency(realizedProfit), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: profitColor)),
              const SizedBox(height: 24),
              _buildProfitRow('보증금', _formatCurrency(currentData['보증금']!)),
              _buildProfitRow('임대료', '+${_formatCurrency(currentData['임대료']!)}', textColor: Colors.red),
              _buildProfitRow('고정 관리비', '-${_formatCurrency(currentData['고정 관리비']!)}', textColor: Colors.blue),
              _buildProfitRow('변동 관리비', '-${_formatCurrency(currentData['변동 관리비']!)}', textColor: Colors.blue),
              _buildProfitRow('미납금', _formatCurrency(currentData['미납금']!)),
              const SizedBox(height: 32),
              _buildRevenueDetailsSection(),
            ],
          ),
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
}
