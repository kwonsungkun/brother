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
  const EmptyRoomListScreen({super.key});

  @override
  State<EmptyRoomListScreen> createState() => _EmptyRoomListScreenState();
}

class _EmptyRoomListScreenState extends State<EmptyRoomListScreen> {
  // --- 상태 변수 ---
  final List<EmptyRoomSummary> _emptyRoomList = [
    const EmptyRoomSummary(buildingName: '드림타워', roomNumber: '102호', propertyType: '상가', vacancyDuration: '120일', leaseCondition: '1억 / 400', detail: EmptyRoomDetail(propertyAddress: '드림타워 102호', propertyType: '상가', vacancyStartDate: '2024-04-01', vacancyDuration: '120일', desiredLeaseCondition: '보증금 1억원 / 월세 400만원', previousLeaseCondition: '보증금 1억원 / 월세 450만원', cleaningStatus: '원상복구 완료', wallpaperStatus: '-', mainOptions: '천장형 에어컨, 화장실', repairHistory: '-', lastInspectionDate: '2024-07-18', inspectionItems: '전기, 수도 점검', actionTaken: '특이사항 없음', periodicChecks: '주 1회 환기', managementFee: '월 30만원', utilityBills: '기본료 납부 중', otherCosts: '-', totalCosts: '90만원', registeredAgencies: '행운부동산', onlinePlatforms: '네이버 부동산', adContent: '1층 코너 상가, 권리금 없음', showingHistory: '2024-07-20: 1팀 방문 (보류)', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '전자키', securityChecks: 'CCTV 작동 중')),
    const EmptyRoomSummary(buildingName: '플러스 빌딩', roomNumber: '301호', propertyType: '사무실', vacancyDuration: '35일', leaseCondition: '5000 / 70', detail: EmptyRoomDetail(propertyAddress: '플러스 빌딩 301호', propertyType: '사무실', vacancyStartDate: '2024-06-20', vacancyDuration: '35일', desiredLeaseCondition: '보증금 5,000만원 / 월세 70만원', previousLeaseCondition: '보증금 5,000만원 / 월세 75만원', cleaningStatus: '입주 청소 완료', wallpaperStatus: '양호', mainOptions: '에어컨, 싱크대', repairHistory: '2024-06-18: 에어컨 필터 교체', lastInspectionDate: '2024-07-20', inspectionItems: '누수, 결로, 파손 여부 확인', actionTaken: '특이사항 없음', periodicChecks: '주 1회 환기 실시 중', managementFee: '월 5만원', utilityBills: '전기, 수도 기본료', otherCosts: '입주 청소비 15만원', totalCosts: '22만원', registeredAgencies: '강남부동산, 우리부동산', onlinePlatforms: '직방, 다방', adContent: '채광 좋은 코너 사무실, 즉시 입주 가능', showingHistory: '2024-07-15: 1팀 방문 (긍정적)', inquiryStatus: '전화 문의 3건', leaseConditionChanges: '2024-07-10: 월세 75만원 -> 70만원으로 조정', doorLockInfo: '비밀번호 1234#', securityChecks: '창문 잠김 상태 양호')),
    const EmptyRoomSummary(buildingName: '해피니스', roomNumber: '501호', propertyType: '주거', vacancyDuration: '5일', leaseCondition: '2억 / 100', detail: EmptyRoomDetail(propertyAddress: '해피니스 501호', propertyType: '주거', vacancyStartDate: '2024-07-20', vacancyDuration: '5일', desiredLeaseCondition: '보증금 2억원 / 월세 100만원', previousLeaseCondition: '보증금 2억원 / 월세 100만원', cleaningStatus: '입주 청소 완료', wallpaperStatus: '최상', mainOptions: '풀옵션', repairHistory: '-', lastInspectionDate: '2024-07-25', inspectionItems: '전체 점검', actionTaken: '특이사항 없음', periodicChecks: '매일 환기', managementFee: '월 10만원', utilityBills: '기본료', otherCosts: '-', totalCosts: '10만원', registeredAgencies: '모두의부동산', onlinePlatforms: '피터팬', adContent: '신축급 풀옵션 원룸', showingHistory: '-', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '스마트 도어락', securityChecks: '완료')),
    const EmptyRoomSummary(buildingName: '강남타워', roomNumber: '2205호', propertyType: '오피스텔', vacancyDuration: '95일', leaseCondition: '1억 / 90', detail: EmptyRoomDetail(propertyAddress: '강남타워 2205호', propertyType: '오피스텔', vacancyStartDate: '2024-05-01', vacancyDuration: '95일', desiredLeaseCondition: '1억/90', previousLeaseCondition: '1억/90', cleaningStatus: '완료', wallpaperStatus: '양호', mainOptions: '풀옵션', repairHistory: '없음', lastInspectionDate: '2024-07-28', inspectionItems: '전체', actionTaken: '없음', periodicChecks: '주1회', managementFee: '15만원', utilityBills: '-', otherCosts: '-', totalCosts: '-', registeredAgencies: '강남부동산', onlinePlatforms: '-', adContent: '강남역 인근', showingHistory: '-', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '-', securityChecks: '-')),    const EmptyRoomSummary(buildingName: '리버뷰', roomNumber: '801호', propertyType: '아파트', vacancyDuration: '150일', leaseCondition: '10억 / 300', detail: EmptyRoomDetail(propertyAddress: '리버뷰 801호', propertyType: '아파트', vacancyStartDate: '2024-03-01', vacancyDuration: '150일', desiredLeaseCondition: '10억/300', previousLeaseCondition: '10억/350', cleaningStatus: '완료', wallpaperStatus: '양호', mainOptions: '-', repairHistory: '없음', lastInspectionDate: '2024-07-28', inspectionItems: '전체', actionTaken: '없음', periodicChecks: '주1회', managementFee: '30만원', utilityBills: '-', otherCosts: '-', totalCosts: '-', registeredAgencies: '한강부동산', onlinePlatforms: '-', adContent: '한강뷰 아파트', showingHistory: '-', inquiryStatus: '-', leaseConditionChanges: '-', doorLockInfo: '-', securityChecks: '-')),
  ];

  VacancyFilterType _activeFilter = VacancyFilterType.none;
  List<EmptyRoomSummary> _filteredList = [];
  RoomSortCriterion _sortCriterion = RoomSortCriterion.duration;
  SortOrder _sortOrder = SortOrder.descending;

  @override
  void initState() {
    super.initState();
    _sortList(); // 초기 정렬 실행
  }

  void _sortList() {
    _emptyRoomList.sort((a, b) {
      int comparison;
      switch (_sortCriterion) {
        case RoomSortCriterion.building:
          comparison = a.buildingName.compareTo(b.buildingName);
          break;
        case RoomSortCriterion.duration:
          final daysA = int.tryParse(a.vacancyDuration.replaceAll('일', '')) ?? 0;
          final daysB = int.tryParse(b.vacancyDuration.replaceAll('일', '')) ?? 0;
          comparison = daysA.compareTo(daysB);
          break;
        case RoomSortCriterion.type:
          comparison = a.propertyType.compareTo(b.propertyType);
          break;
      }
      return _sortOrder == SortOrder.ascending ? comparison : -comparison;
    });
  }

  void _showSortDialog() {
    RoomSortCriterion tempCriterion = _sortCriterion;
    SortOrder tempOrder = _sortOrder;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정렬'),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), child: Text('순서', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                    RadioListTile<SortOrder>(title: const Text('오름차순'), value: SortOrder.ascending, groupValue: tempOrder, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempOrder = v!)),
                    RadioListTile<SortOrder>(title: const Text('내림차순'), value: SortOrder.descending, groupValue: tempOrder, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempOrder = v!)),
                    const Divider(),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), child: Text('정렬 기준', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                    RadioListTile<RoomSortCriterion>(title: const Text('건물명'), value: RoomSortCriterion.building, groupValue: tempCriterion, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempCriterion = v!)),
                    RadioListTile<RoomSortCriterion>(title: const Text('공실기간'), value: RoomSortCriterion.duration, groupValue: tempCriterion, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempCriterion = v!)),
                    RadioListTile<RoomSortCriterion>(title: const Text('종류'), value: RoomSortCriterion.type, groupValue: tempCriterion, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempCriterion = v!)),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(child: const Text('취소'), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                setState(() {
                  _sortCriterion = tempCriterion;
                  _sortOrder = tempOrder;
                  _sortList();
                  _applyFilter(_activeFilter);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showNotificationSentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('메세지를 발송하였습니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _applyFilter(VacancyFilterType filter) {
    setState(() {
      _activeFilter = filter;
      switch (filter) {
        case VacancyFilterType.all:
          _filteredList = _emptyRoomList;
          break;
        case VacancyFilterType.recent:
          _filteredList = _emptyRoomList.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) <= 30).toList();
          break;
        case VacancyFilterType.longterm:
          _filteredList = _emptyRoomList.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) > 90).toList();
          break;
        case VacancyFilterType.none:
          _filteredList = [];
          break;
      }
    });
  }

  void _onItemTapped(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildSummaryCard(String title, String value, String unit, {Color? highlightColor, VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: highlightColor ?? Colors.black)),
                    const SizedBox(width: 4),
                    Text(unit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildVacancyListItem(EmptyRoomSummary summary) {
    final days = int.tryParse(summary.vacancyDuration.replaceAll('일', '')) ?? 0;
    Color tagColor;
    if (days > 90) {
      tagColor = Colors.red[100]!;
    } else if (days > 30) {
      tagColor = Colors.yellow[200]!;
    } else {
      tagColor = Colors.green[100]!;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmptyRoomDetailScreen(detail: summary.detail))),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${summary.buildingName} ${summary.roomNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('종류: ${summary.propertyType}', style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Text('임대조건: ${summary.leaseCondition}', style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(summary.vacancyDuration, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardBody() {
    final totalVacancies = _emptyRoomList.length;
    final avgDays = _emptyRoomList.isEmpty ? 0 : _emptyRoomList.map((e) => int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0).reduce((a, b) => a + b) ~/ _emptyRoomList.length;
    final newVacancies = _emptyRoomList.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) <= 30).length;
    final longTermVacancies = _emptyRoomList.where((e) => (int.tryParse(e.vacancyDuration.replaceAll('일', '')) ?? 0) > 90).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('요약', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
            children: [
              _buildSummaryCard('총 공실', '$totalVacancies', '건', onTap: () => _applyFilter(VacancyFilterType.all)),
              _buildSummaryCard('평균 공실일', '$avgDays', '일'),
              _buildSummaryCard('신규 (30일내)', '$newVacancies', '건', highlightColor: Colors.blueAccent, onTap: () => _applyFilter(VacancyFilterType.recent)),
              _buildSummaryCard('장기 (90일+)', '$longTermVacancies', '건', highlightColor: Colors.red, onTap: () => _applyFilter(VacancyFilterType.longterm)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('주요 공실', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if(_activeFilter == VacancyFilterType.none) // 대시보드 상태일 때만 보이도록 수정
                TextButton(
                  onPressed: () => _applyFilter(VacancyFilterType.all),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('전체 목록 보기'), Icon(Icons.arrow_forward)]),
                  style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _emptyRoomList.length > 3 ? 3 : _emptyRoomList.length,
            itemBuilder: (context, index) => _buildVacancyListItem(_emptyRoomList[index]),
          ),
        ],
      ),
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
    if (_activeFilter == VacancyFilterType.all) title = '전체 공실 목록';
    if (_activeFilter == VacancyFilterType.recent) title = '신규 공실 목록';
    if (_activeFilter == VacancyFilterType.longterm) title = '장기 공실 목록';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: _activeFilter != VacancyFilterType.none 
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _activeFilter = VacancyFilterType.none))
            : null,
        actions: [
          if (_activeFilter != VacancyFilterType.none) ...[
            IconButton(icon: const Icon(Icons.sort), onPressed: _showSortDialog, tooltip: '정렬'),
          ] else ...[
            IconButton(icon: const Icon(Icons.campaign), onPressed: _showNotificationSentDialog, tooltip: '알림'), // 아이콘 변경
          ]
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: _activeFilter == VacancyFilterType.none ? _buildDashboardBody() : _buildFilteredListBody(),
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
