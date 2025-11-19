import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';
import 'empty_room_detail_screen.dart';

// --- 데이터 모델 및 열거형 ---
class EmptyRoomSummary {
  final String buildingName, roomNumber, propertyType, vacancyDuration, leaseCondition;
  final EmptyRoomDetail detail;
  const EmptyRoomSummary({ required this.buildingName, required this.roomNumber, required this.propertyType, required this.vacancyDuration, required this.leaseCondition, required this.detail });
}

enum VacancyFilterType { none, all, recent, longterm }
enum RoomSortCriterion { building, duration, type }
enum SortOrder { ascending, descending }

// --- 화면 위젯 ---
class EmptyRoomListScreen extends StatefulWidget {
  final String? buildingName;
  const EmptyRoomListScreen({super.key, this.buildingName});

  @override
  State<EmptyRoomListScreen> createState() => _EmptyRoomListScreenState();
}

class _EmptyRoomListScreenState extends State<EmptyRoomListScreen> {
  final List<EmptyRoomSummary> _allRooms = [
    const EmptyRoomSummary(buildingName: '골든파크빌', roomNumber: '404호', propertyType: '주거', vacancyDuration: '10일', leaseCondition: '5000 / 60', detail: EmptyRoomDetail(propertyAddress: '골든파크빌 404호', propertyType: '주거', vacancyStartDate: '2024-07-15', vacancyDuration: '10일', desiredLeaseCondition: '5000/60', previousLeaseCondition: '5000/60', cleaningStatus: '완료', wallpaperStatus: '양호', mainOptions: '-', repairHistory: '-', lastInspectionDate: '-', inspectionItems: '-', actionTaken: '-', periodicChecks: '-', managementFee: '-', utilityBills: '-', otherCosts: '-', totalCosts: '-', registeredAgencies: '-', onlinePlatforms: '-', adContent: '-', showingHistory: '-', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '-', securityChecks: '-')),
    const EmptyRoomSummary(buildingName: '골든파크빌', roomNumber: '301호', propertyType: '주거', vacancyDuration: '25일', leaseCondition: '1억 / 30', detail: EmptyRoomDetail(propertyAddress: '골든파크빌 301호', propertyType: '주거', vacancyStartDate: '2024-07-01', vacancyDuration: '25일', desiredLeaseCondition: '1억/30', previousLeaseCondition: '1억/30', cleaningStatus: '완료', wallpaperStatus: '양호', mainOptions: '-', repairHistory: '-', lastInspectionDate: '-', inspectionItems: '-', actionTaken: '-', periodicChecks: '-', managementFee: '-', utilityBills: '-', otherCosts: '-', totalCosts: '-', registeredAgencies: '-', onlinePlatforms: '-', adContent: '-', showingHistory: '-', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '-', securityChecks: '-')),
    const EmptyRoomSummary(buildingName: '강남 럭키빌딩', roomNumber: '102호', propertyType: '오피스텔', vacancyDuration: '5일', leaseCondition: '1억 / 150', detail: EmptyRoomDetail(propertyAddress: '강남 럭키빌딩 102호', propertyType: '오피스텔', vacancyStartDate: '2024-07-20', vacancyDuration: '5일', desiredLeaseCondition: '1억/150', previousLeaseCondition: '1억/150', cleaningStatus: '완료', wallpaperStatus: '양호', mainOptions: '-', repairHistory: '-', lastInspectionDate: '-', inspectionItems: '-', actionTaken: '-', periodicChecks: '-', managementFee: '-', utilityBills: '-', otherCosts: '-', totalCosts: '-', registeredAgencies: '-', onlinePlatforms: '-', adContent: '-', showingHistory: '-', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '-', securityChecks: '-')),
  ];

  late List<EmptyRoomSummary> _filteredList;
  VacancyFilterType _activeFilter = VacancyFilterType.none;
  RoomSortCriterion _sortCriterion = RoomSortCriterion.duration;
  SortOrder _sortOrder = SortOrder.descending;

  @override
  void initState() {
    super.initState();
    _sortList();
    if (widget.buildingName != null) {
      _activeFilter = VacancyFilterType.all;
      _applyFilterForBuilding(widget.buildingName!);
    } else {
      _filteredList = _allRooms;
    }
  }

  void _sortList() { /* ... */ }
  void _showSortDialog() { /* ... */ }
  void _showNotificationSentDialog() { /* ... */ }

  void _applyFilter(VacancyFilterType filter) {
    setState(() {
      _activeFilter = filter;
      if (widget.buildingName != null) { _applyFilterForBuilding(widget.buildingName!); return; }
      switch (filter) {
        case VacancyFilterType.all: _filteredList = _allRooms; break;
        case VacancyFilterType.recent: _filteredList = _allRooms.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) <= 30).toList(); break;
        case VacancyFilterType.longterm: _filteredList = _allRooms.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) > 90).toList(); break;
        case VacancyFilterType.none: _filteredList = _allRooms; break;
      }
    });
  }
  
  void _applyFilterForBuilding(String buildingName) {
    final buildingOnlyName = buildingName.split('(').first;
    setState(() {
        _filteredList = _allRooms.where((e) => e.buildingName.contains(buildingOnlyName)).toList();
    });
  }

  void _onItemTapped(int index) { Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),(Route<dynamic> route) => false,); }
  
  Widget _buildSummaryCard(String title, String value, String unit, {Color? highlightColor, VoidCallback? onTap}) {
    return Card(elevation: 2, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])), const Spacer(), FittedBox(fit: BoxFit.scaleDown, child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: highlightColor ?? Colors.black)), const SizedBox(width: 4), Text(unit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]))]))));
  }

  Widget _buildVacancyListItem(EmptyRoomSummary summary) {
    final days = int.tryParse(summary.vacancyDuration.replaceAll('일', '')) ?? 0;
    Color tagColor = days > 90 ? Colors.red[100]! : (days > 30 ? Colors.yellow[200]! : Colors.green[100]!);

    return Card(elevation: 2, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmptyRoomDetailScreen(detail: summary.detail))), borderRadius: BorderRadius.circular(12), child: Padding(padding: const EdgeInsets.all(16.0), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${summary.buildingName} ${summary.roomNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text('종류: ${summary.propertyType}', style: TextStyle(color: Colors.grey[700])), const SizedBox(height: 4), Text('임대조건: ${summary.leaseCondition}', style: TextStyle(color: Colors.grey[700]))])), const SizedBox(width: 16), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(20)), child: Text(summary.vacancyDuration, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)))]))));
  }

  Widget _buildDashboardBody() {
    final totalVacancies = _allRooms.length;
    final avgDays = _allRooms.isEmpty ? 0 : _allRooms.map((e) => int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0).reduce((a, b) => a + b) ~/ _allRooms.length;
    final newVacancies = _allRooms.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) <= 30).length;
    final longTermVacancies = _allRooms.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) > 90).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('요약', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.0, children: [
          _buildSummaryCard('총 공실', '$totalVacancies', '건', onTap: () => _applyFilter(VacancyFilterType.all)),
          _buildSummaryCard('평균 공실일', '$avgDays', '일'),
          _buildSummaryCard('신규 (30일내)', '$newVacancies', '건', highlightColor: Colors.blueAccent, onTap: () => _applyFilter(VacancyFilterType.recent)),
          _buildSummaryCard('장기 (90일+)', '$longTermVacancies', '건', highlightColor: Colors.red, onTap: () => _applyFilter(VacancyFilterType.longterm)),
        ]),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('주요 공실', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if(_activeFilter == VacancyFilterType.none)
            TextButton(onPressed: () => _applyFilter(VacancyFilterType.all), child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('전체 목록 보기'), Icon(Icons.arrow_forward)]), style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),),
        ]),
        const SizedBox(height: 12),
        ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: _allRooms.length > 3 ? 3 : _allRooms.length, itemBuilder: (context, index) => _buildVacancyListItem(_allRooms[index])),
      ]),
    );
  }

  Widget _buildFilteredListBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) => _buildVacancyListItem(_filteredList[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = '공실 관리';
    bool isDashboard = _activeFilter == VacancyFilterType.none && widget.buildingName == null;

    if (widget.buildingName != null) {
      title = '공실 관리 (${widget.buildingName!.split('(').first})';
    } else {
      if (_activeFilter == VacancyFilterType.all) title = '전체 공실 목록';
      if (_activeFilter == VacancyFilterType.recent) title = '신규 공실 목록';
      if (_activeFilter == VacancyFilterType.longterm) title = '장기 공실 목록';
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
        leading: !isDashboard ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
          if (widget.buildingName != null) { Navigator.of(context).pop(); } else { setState(() => _activeFilter = VacancyFilterType.none); }
        }) : null,
        actions: [ if (!isDashboard) IconButton(icon: const Icon(Icons.sort), onPressed: _showSortDialog, tooltip: '정렬') else IconButton(icon: const Icon(Icons.campaign), onPressed: _showNotificationSentDialog, tooltip: '알림') ],
      ),
      backgroundColor: Colors.grey[100],
      body: isDashboard ? _buildDashboardBody() : _buildFilteredListBody(),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[ BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'), BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'), BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'), BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'), BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보'),], currentIndex: 0, selectedItemColor: Colors.blueAccent, unselectedItemColor: Colors.grey, onTap: _onItemTapped, type: BottomNavigationBarType.fixed,),
    );
  }
}
