import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';
import 'unpaid_detail_screen.dart';

enum SortCriterion { name, paymentDate, unpaidAmount, daysLeft }
enum SortOrder { ascending, descending }

class UnpaidSummary {
  final String buildingName, tenantName, tenantContact, unpaidAmount;
  final int unpaidCount, paymentDate;
  final UnpaidDetail detail;
  const UnpaidSummary({ required this.buildingName, required this.tenantName, required this.tenantContact, required this.unpaidCount, required this.unpaidAmount, required this.paymentDate, required this.detail });
}

class MoveOutSummary {
  final String tenantName, buildingName, roomNumber, contractEndDate;
  final int daysLeft;
  final UnpaidDetail detail;
  const MoveOutSummary({ required this.tenantName, required this.buildingName, required this.roomNumber, required this.contractEndDate, required this.daysLeft, required this.detail });
}

class UnpaidListScreen extends StatefulWidget {
  final String? buildingName;
  const UnpaidListScreen({super.key, this.buildingName});

  @override
  State<UnpaidListScreen> createState() => _UnpaidListScreenState();
}

class _UnpaidListScreenState extends State<UnpaidListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<UnpaidSummary> _allUnpaidList = [
    UnpaidSummary(buildingName: '골든파크빌', tenantName: '오승준', tenantContact: '010-1234-5678', unpaidCount: 2, unpaidAmount: '1,500,000원', paymentDate: 25, detail: const UnpaidDetail(propertyAddress: '부산광역시 서구 아미동2가 19-8(골든파크빌) 201호', tenantName: '오승준', tenantContact: '010-1234-5678', contractPeriod: '2023-01-01 ~ 2025-01-01', deposit: '50,000,000원', monthlyRent: '700,000원', managementFee: '50,000원', paymentTerms: '매월 25일, 신한은행 110-***-***', unpaidMonths: '2024년 6월, 7월', unpaidItems: '월세, 관리비', unpaidAmountForMonth: '750,000원', cumulativeUnpaidCount: 2, cumulativeUnpaidTotal: '1,500,000원', lateInterest: '5,000원', remainingDeposit: '48,495,000원')),
    UnpaidSummary(buildingName: '강남 럭키빌딩', tenantName: '권성근', tenantContact: '010-9876-5432', unpaidCount: 1, unpaidAmount: '950,000원', paymentDate: 1, detail: const UnpaidDetail(propertyAddress: '서울시 강남구 테헤란로 123(강남 럭키빌딩) 302호', tenantName: '권성근', tenantContact: '010-9876-5432', contractPeriod: '2024-03-01 ~ 2026-03-01', deposit: '100,000,000원', monthlyRent: '900,000원', managementFee: '50,000원', paymentTerms: '매월 1일, 우리은행 1002-***-***', unpaidMonths: '2024년 7월', unpaidItems: '월세, 관리비', unpaidAmountForMonth: '950,000원', cumulativeUnpaidCount: 1, cumulativeUnpaidTotal: '950,000원', lateInterest: '없음', remainingDeposit: '99,050,000원')),
  ];
  final List<MoveOutSummary> _allMoveOutUnpaidList = [
    const MoveOutSummary(tenantName: '이영희', buildingName: '강남 럭키빌딩', roomNumber: '103동 405호', contractEndDate: '2024-08-30', daysLeft: 36, detail: UnpaidDetail(propertyAddress: '강남 럭키빌딩 103동 405호', tenantName: '이영희', tenantContact: '010-7777-8888', contractPeriod: '2022-08-31 ~ 2024-08-30', deposit: '50,000,000원', monthlyRent: '750,000원', managementFee: '0원', paymentTerms: '매월 30일', unpaidMonths: '2024년 6월, 7월', unpaidItems: '월세', unpaidAmountForMonth: '750,000원', cumulativeUnpaidCount: 2, cumulativeUnpaidTotal: '1,500,000원', lateInterest: '8,000원', remainingDeposit: '48,492,000원')),
  ];

  late List<UnpaidSummary> _unpaidList;
  late List<MoveOutSummary> _moveOutUnpaidList;
  bool _isSelectionMode = false;
  final Set<dynamic> _selectedItems = {};
  SortCriterion _unpaidSortCriterion = SortCriterion.paymentDate;
  SortOrder _unpaidSortOrder = SortOrder.descending;
  SortCriterion _moveOutSortCriterion = SortCriterion.daysLeft;
  SortOrder _moveOutSortOrder = SortOrder.ascending;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.buildingName != null) {
      _unpaidList = _allUnpaidList.where((item) => item.buildingName == widget.buildingName).toList();
      _moveOutUnpaidList = _allMoveOutUnpaidList.where((item) => item.buildingName == widget.buildingName).toList();
    } else {
      _unpaidList = _allUnpaidList;
      _moveOutUnpaidList = _allMoveOutUnpaidList;
    }

    _sortUnpaidList(); 
    _sortMoveOutList(); 
  }
  
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }
  
  void _sortUnpaidList() { /* ... */ }
  void _sortMoveOutList() { /* ... */ }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(children: <Widget>[
            ListTile(leading: const Icon(Icons.check_box_outline_blank), title: const Text('선택'), onTap: () { Navigator.pop(context); setState(() => _isSelectionMode = true); }),
            ListTile(leading: const Icon(Icons.sort), title: const Text('정렬 기준'), onTap: () { Navigator.pop(context); _showSortDialog(); }),
          ]),
        );
      },
    );
  }

  void _onItemTapped(int index) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),(Route<dynamic> route) => false,);
  void _showSentConfirmationDialog() { /* ... */ }
  void _showNotificationMethodDialog() { /* ... */ }
  void _handleSendNotification() { /* ... */ }
  void _showSortDialog() { /* ... */ }

  AppBar _buildAppBar() {
    if (_isSelectionMode) {
      return AppBar(
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 1,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() { _isSelectionMode = false; _selectedItems.clear(); })),
        title: Text('${_selectedItems.length}개 선택'),
        actions: [IconButton(icon: const Icon(Icons.campaign), onPressed: _selectedItems.isNotEmpty ? _showNotificationMethodDialog : null, tooltip: '알림 보내기')],
      );
    }

    String title = '미납 관리';
    if (widget.buildingName != null) {
      title += ' (${widget.buildingName})';
    }

    return AppBar(
        title: Text(title),
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.campaign), onPressed: _handleSendNotification, tooltip: '알림'),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: _showMoreOptions, tooltip: '더보기'),
        ],
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: '미납 목록'), Tab(text: '퇴실예정(미납)')], labelColor: Colors.black, unselectedLabelColor: Colors.grey, indicatorColor: Colors.black), 
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TabBarView(controller: _tabController, children: [_buildUnpaidList(), _buildMoveOutList()]),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'), BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'), BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'), BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'), BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보')], currentIndex: 0, selectedItemColor: Colors.deepPurple.shade400, unselectedItemColor: Colors.grey, onTap: _onItemTapped, type: BottomNavigationBarType.fixed),
    );
  }

  Widget _buildUnpaidList() {
    return ListView.builder(
      itemCount: _unpaidList.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final summary = _unpaidList[index];
        final isSelected = _selectedItems.contains(summary);
        return Card(
          elevation: 2, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () {
              if (_isSelectionMode) {
                setState(() { isSelected ? _selectedItems.remove(summary) : _selectedItems.add(summary); });
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UnpaidDetailScreen(detail: summary.detail)));
              }
            },
            leading: _isSelectionMode ? Checkbox(value: isSelected, onChanged: (bool? value) { setState(() { value! ? _selectedItems.add(summary) : _selectedItems.remove(summary); }); }) : null,
            contentPadding: const EdgeInsets.all(16),
            title: Text(summary.tenantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              Text('${summary.buildingName} / ${summary.tenantContact}'),
              const SizedBox(height: 4),
              Text.rich(TextSpan(style: TextStyle(color: Colors.grey[700]), children: [TextSpan(text: '연체일: ${summary.paymentDate}일 / '), TextSpan(text: summary.unpaidAmount, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))])),
            ]),
            trailing: !_isSelectionMode ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
          ),
        );
      },
    );
  }

  Widget _buildMoveOutList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _moveOutUnpaidList.length,
      itemBuilder: (context, index) {
        final summary = _moveOutUnpaidList[index];
        final isSelected = _selectedItems.contains(summary);
        return Card(
          elevation: 2, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () {
              if (_isSelectionMode) {
                setState(() { isSelected ? _selectedItems.remove(summary) : _selectedItems.add(summary); });
              } else {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => UnpaidDetailScreen(detail: summary.detail, showDepositSettlement: true)));
              }
            },
            leading: _isSelectionMode ? Checkbox(value: isSelected, onChanged: (bool? value) { setState(() { value! ? _selectedItems.add(summary) : _selectedItems.remove(summary); }); }) : null,
            contentPadding: const EdgeInsets.all(16),
            title: Text(summary.tenantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 8), Text('${summary.buildingName} ${summary.roomNumber}'), const SizedBox(height: 4), Text('계약만료: ${summary.contractEndDate}')]),
            trailing: !_isSelectionMode ? Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text('${summary.daysLeft}일 남음', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)), if (summary.detail.cumulativeUnpaidCount > 0) Text('미납 ${summary.detail.cumulativeUnpaidCount}건', style: const TextStyle(color: Colors.red, fontSize: 12))]) : null,
          ),
        );
      },
    );
  }
}
