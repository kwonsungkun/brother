import 'package:flutter/material.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // A light grey, similar to iOS system background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Card
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('브라더 머니', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 8),
                      const Text('1,234,567원', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Connected Accounts Card
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildConnectedAccounts(),
                ),
              ),
              const SizedBox(height: 16),
              // History Card
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildHistorySection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('충전', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEFEFF4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text('인출', style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedAccounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('연결된 계좌', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 16),
        _buildAccountTile('KB국민은행', '· · · · 1234'),
        const SizedBox(height: 12),
        _buildAccountTile('신한은행', '· · · · 5678'),
      ],
    );
  }

  Widget _buildAccountTile(String bankName, String accountNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E5EA)),
            ),
            child: Icon(Icons.account_balance, color: Colors.grey[400], size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bankName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              Text(accountNumber, style: TextStyle(fontSize: 14, color: Colors.grey[600], letterSpacing: 1.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    // This is a sample data.
    final List<Map<String, dynamic>> history = [
      {'type': 'deposit', 'title': '월세 입금 - 301호 홍길동', 'date': '4월 15일', 'amount': '+550,000원', 'color': const Color(0xFF007AFF)},
      {'type': 'withdrawal', 'title': '관리비 출금', 'date': '4월 10일', 'amount': '-120,000원', 'color': const Color(0xFFFF3B30)},
      {'type': 'deposit', 'title': '계좌 충전', 'date': '4월 1일', 'amount': '+1,000,000원', 'color': const Color(0xFF007AFF)},
      {'type': 'deposit', 'title': '월세 입금 - 202호 이영희', 'date': '3월 31일', 'amount': '+450,000원', 'color': const Color(0xFF007AFF)},
    ];

    final filteredHistory = history.where((item) {
      if (_selectedFilterIndex == 0) return true;
      if (_selectedFilterIndex == 1) return item['type'] == 'deposit';
      if (_selectedFilterIndex == 2) return item['type'] == 'withdrawal';
      return false;
    }).toList();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('이용 내역', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 16),
        _buildHistoryFilters(),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredHistory.length,
          separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E5EA)),
          itemBuilder: (context, index) {
            final item = filteredHistory[index];
            return _buildHistoryItem(item['title'], item['date'], item['amount'], item['color']);
          },
        )
      ],
    );
  }

  Widget _buildHistoryFilters() {
    final filters = ['전체', '입금', '출금'];
    return Row(
      children: List.generate(filters.length, (index) {
        bool isSelected = _selectedFilterIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(filters[index]),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedFilterIndex = index;
                });
              }
            },
            selectedColor: Colors.deepPurple,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: const Color(0xFFEFEFF4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        );
      }),
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String amount, Color amountColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, color: Colors.black)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
          const Spacer(),
          Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: amountColor)),
        ],
      ),
    );
  }
}
