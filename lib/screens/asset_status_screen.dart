import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/file_manager_screen.dart';
import 'package:project/screens/unit_detail_screen.dart';
import 'package:project/screens/annual_rent_summary_screen.dart';
import 'package:project/screens/home_page.dart';

// --- 데이터 모델 정의 ---
class Unit {
  final String roomNumber, tenantName, expiryDate, deposit, rent, gender, contact, realty, notes, unpaidAmount;
  final String contractDate;
  final bool isVacant;

  const Unit({
    required this.roomNumber, required this.tenantName, required this.isVacant,
    required this.expiryDate, required this.deposit, required this.rent, 
    required this.gender, required this.contact, required this.realty, 
    required this.notes, required this.contractDate, required this.unpaidAmount,
  });
}

class Building {
  final String name, address;
  final int totalUnits, vacantUnits;
  final List<Unit> units;
  const Building({ required this.name, required this.address, required this.totalUnits, required this.vacantUnits, required this.units });
}

class AssetStatusScreen extends StatefulWidget {
  const AssetStatusScreen({super.key});

  @override
  State<AssetStatusScreen> createState() => _AssetStatusScreenState();
}

class _AssetStatusScreenState extends State<AssetStatusScreen> {
  int _selectedBuildingIndex = 0;
  late ScrollController _scrollController;

  final List<Building> _buildings = [
    Building(
      name: '강남 럭키빌딩', address: '서울시 강남구 테헤란로 123', totalUnits: 15, vacantUnits: 1, 
      units: [
        const Unit(roomNumber: '101호', tenantName: '김철수', isVacant: false, expiryDate: '2025-10-31', deposit: '1억', rent: '150만원', gender: '남성', contact: '010-1111-2222', realty: '강남부동산', notes: '애완동물(강아지) 키움.', contractDate: '2023-11-01', unpaidAmount: '0원'),
        const Unit(roomNumber: '102호', tenantName: '-', isVacant: true, expiryDate: '-', deposit: '-', rent: '-', gender: '-', contact: '-', realty: '-', notes: '도배, 장판 새로 완료.', contractDate: '-', unpaidAmount: '0원'),
        const Unit(roomNumber: '201호', tenantName: '이영희', isVacant: false, expiryDate: '2025-03-15', deposit: '1.2억', rent: '160만원', gender: '여성', contact: '010-3333-4444', realty: '강남부동산', notes: '-', contractDate: '2023-03-16', unpaidAmount: '160만원'),
        const Unit(roomNumber: '202호', tenantName: '박지민', isVacant: false, expiryDate: '2026-01-20', deposit: '1억', rent: '155만원', gender: '남성', contact: '010-5555-6666', realty: '삼성부동산', notes: '-', contractDate: '2024-01-21', unpaidAmount: '0원'),
        const Unit(roomNumber: '301호', tenantName: '최유나', isVacant: false, expiryDate: '2024-12-10', deposit: '5천만원', rent: '120만원', gender: '여성', contact: '010-7777-8888', realty: '강남부동산', notes: '-', contractDate: '2022-12-11', unpaidAmount: '0원'),
      ]
    ),
    const Building(name: '마포 하이츠빌', address: '서울시 마포구 독막로 20', totalUnits: 10, vacantUnits: 2, units: [
        Unit(roomNumber: '101호', tenantName: '정국', isVacant: false, expiryDate: '2025-08-10', deposit: '2억', rent: '180만원', gender: '남성', contact: '010-1234-8888', realty: '마포부동산', notes: '-', contractDate: '2023-08-11', unpaidAmount: '0원'),
        Unit(roomNumber: '102호', tenantName: '-', isVacant: true, expiryDate: '-', deposit: '-', rent: '-', gender: '-', contact: '-', realty: '-', notes: '-', contractDate: '-', unpaidAmount: '0원'),
      ]),
    const Building(name: '분당 스카이뷰', address: '경기도 성남시 분당구 정자로 1', totalUnits: 25, vacantUnits: 3, units: [
        Unit(roomNumber: 'A동 101호', tenantName: '김남준', isVacant: false, expiryDate: '2025-01-01', deposit: '3억', rent: '250만원', gender: '남성', contact: '010-5678-1234', realty: '분당부동산', notes: '-', contractDate: '2023-01-02', unpaidAmount: '0원'),
      ]),
    const Building(name: '일산 드림팰리스', address: '경기도 고양시 일산동구 중앙로 123', totalUnits: 30, vacantUnits: 0, units: [
        Unit(roomNumber: '101호', tenantName: '민윤기', isVacant: false, expiryDate: '2026-06-30', deposit: '4억', rent: '100만원', gender: '남성', contact: '010-4321-8765', realty: '일산부동산', notes: '-', contractDate: '2024-07-01', unpaidAmount: '0원'),
      ]),
  ];

  @override
  void initState() { super.initState(); _scrollController = ScrollController(); }
  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }
  
  void _scrollToIndex(int index) {
    const double itemWidth = 200.0;
    const double spacing = 12.0;
    final double scrollPosition = index * (itemWidth + spacing);
    _scrollController.animateTo(scrollPosition, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _showAssetMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(children: <Widget>[
            ListTile(leading: const Icon(Icons.add_business_outlined), title: const Text('자산추가'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.person_add_alt_1_outlined), title: const Text('임차인등록'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.edit_outlined), title: const Text('자산수정'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.edit_note_outlined), title: const Text('임대인수정'), onTap: () => Navigator.pop(context)),
          ]),
        );
      },
    );
  }

  // 2. 화면 이동 함수 추가
  void _onItemTapped(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('장부관리'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.folder_copy_outlined), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FileManagerScreen())), tooltip: '파일 관리'),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: _showAssetMoreOptions, tooltip: '더보기'),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildBuildingSelectionSection(), const SizedBox(height: 24), _buildUnitStatusSection()])),
      // 3. 네비게이션 바 추가
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

  Widget _buildBuildingSelectionSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('보유 건물 현황', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: _selectedBuildingIndex > 0 ? () { final newIndex = _selectedBuildingIndex - 1; setState(() => _selectedBuildingIndex = newIndex); _scrollToIndex(newIndex); } : null),
          Expanded(child: SizedBox(height: 100, child: ListView.separated(controller: _scrollController, scrollDirection: Axis.horizontal, itemCount: _buildings.length, separatorBuilder: (context, index) => const SizedBox(width: 12), itemBuilder: (context, index) { final building = _buildings[index]; final isSelected = index == _selectedBuildingIndex; return InkWell(onTap: () { setState(() => _selectedBuildingIndex = index); _scrollToIndex(index); }, child: Card(elevation: 2, color: isSelected ? Colors.blue.shade50 : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isSelected ? BorderSide(color: Colors.blue.shade300, width: 2) : BorderSide.none), child: Container(width: 200, padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(building.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const Spacer(), Text(building.address, style: TextStyle(fontSize: 12, color: Colors.grey[600]), overflow: TextOverflow.ellipsis), 
            Text.rich(TextSpan(style: TextStyle(fontSize: 12, color: Colors.grey[600]), children: [const TextSpan(text: '총 '), TextSpan(text: '${building.totalUnits}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)), const TextSpan(text: '호실 / 공실 '), TextSpan(text: '${building.vacantUnits}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]))
            ])))); },))),
          IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: _selectedBuildingIndex < _buildings.length - 1 ? () { final newIndex = _selectedBuildingIndex + 1; setState(() => _selectedBuildingIndex = newIndex); _scrollToIndex(newIndex); } : null)
        ])
      ]);
  }

  Widget _buildUnitStatusSection() {
    final selectedBuilding = _buildings[_selectedBuildingIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${selectedBuilding.name} - 호실 현황 (${selectedBuilding.units.length}개)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedBuilding.units.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final unit = selectedBuilding.units[index];
            final nameColor = unit.gender == '남성' ? Colors.blueAccent : (unit.gender == '여성' ? Colors.pinkAccent : Colors.black);

            return Card(
              elevation: 2, color: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UnitDetailScreen(unit: unit, building: selectedBuilding))),
                title: Text(unit.roomNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text.rich(TextSpan(children: [const TextSpan(text: '임차인: '), TextSpan(text: unit.tenantName, style: TextStyle(color: nameColor, fontWeight: FontWeight.bold))])),
                    const SizedBox(height: 4),
                    Text('만료일: ${unit.expiryDate}'),
                    Text('보증금/월세: ${unit.deposit}/${unit.rent}'),
                  ],
                ),
                trailing: Text(unit.isVacant ? '공실' : '입주', style: TextStyle(color: unit.isVacant ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
              )
            );
          },
        ),
      ],
    );
  }
}
