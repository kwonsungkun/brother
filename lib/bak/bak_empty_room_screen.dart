import 'package:flutter/material.dart';
import '../widgets/management_menu_widget.dart';

class EmptyRoomScreen extends StatefulWidget {
  const EmptyRoomScreen({super.key});

  @override
  State<EmptyRoomScreen> createState() => _EmptyRoomScreenState();
}

class _EmptyRoomScreenState extends State<EmptyRoomScreen> {
  int _selectedDongIndex = 0;
  int _selectedStackingPlanSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('공실 관리'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAssetSelection(),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDongSelection(),
                  const SizedBox(height: 24),
                  _buildStackingPlan(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('자산 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
                hintText: '관리명, 도로명 주소 검색',
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                suffixIcon: Icon(Icons.search)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('플러스 빌딩 (10/12)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('서울시 강남구 테헤란로 201', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDongSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('동 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ToggleButtons(
          isSelected: [_selectedDongIndex == 0, _selectedDongIndex == 1],
          onPressed: (index) {
            setState(() {
              _selectedDongIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(8.0),
          selectedColor: Colors.white,
          color: Colors.black,
          fillColor: Colors.black,
          borderColor: Colors.grey.shade400,
          selectedBorderColor: Colors.black,
          constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
          children: const [
            Text('A동'),
            Text('B동'),
          ],
        ),
      ],
    );
  }

  Widget _buildStackingPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Stacking Plan(㎡)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            ToggleButtons(
              isSelected: [_selectedStackingPlanSizeIndex == 0, _selectedStackingPlanSizeIndex == 1],
              onPressed: (index) {
                setState(() {
                  _selectedStackingPlanSizeIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(20),
              selectedColor: Theme.of(context).primaryColor,
              color: Colors.black,
              fillColor: Colors.transparent,
              renderBorder: false,
              children: [
                Row(children: [
                  Icon(_selectedStackingPlanSizeIndex == 0 ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: _selectedStackingPlanSizeIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
                  const SizedBox(width: 4),
                  const Text('100%')
                ]),
                Row(children: [
                  Icon(_selectedStackingPlanSizeIndex == 1 ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: _selectedStackingPlanSizeIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
                  const SizedBox(width: 4),
                  const Text('200%')
                ]),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFloorInfo(),
                _buildUnits(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloorInfo() {
    return Column(
      children: [
        _floorInfoCell('옥탑 1층', '30,000,000.1234/\n30,000,000.1234'),
        _floorInfoCell('지상 3층', '10,000.1234/\n30,000,000.1234'),
        _floorInfoCell('지상 2층', '3,000.1234/\n30,000,000.1234'),
        _floorInfoCell('지상 1층', '2,000.0000/\n30,000,000.1234'),
        _floorInfoCell('지하 1층', '0.0000/\n30,000,000.1234'),
      ],
    );
  }

  Widget _floorInfoCell(String floor, String info) {
    return Container(
      width: 150,
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(floor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(info, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildUnits() {
    return Column(
      children: [
        _unitFloorRow(['옥탑층'], height: 80, flexMap: {'옥탑층': 1}),
        _unitFloorRow(['3-A', '3-B', '3-C', '3-D', '3-E'], height: 80, flexMap: {'3-A': 1, '3-B': 1, '3-C': 1, '3-D': 1, '3-E': 2}),
        _unitFloorRow(['201호', '202호', '203호', '204호', '205호', '206호', '207호', '208호', '210호', '211호', '212호'], height: 80),
        _unitFloorRow(['1-A', '1-B', '1-C', '1-D', '1-E', '', '1-H', '1-I'], height: 80, flexMap: {'1-A': 1, '1-B': 1, '1-C': 1, '1-D': 1, '1-E': 1, '': 1, '1-H': 2, '1-I': 2}),
        _unitFloorRow(['지하주차장'], height: 80, flexMap: {'지하주차장': 1}),
      ],
    );
  }

  Widget _unitFloorRow(List<String> units, {double height = 60, Map<String, int> flexMap = const {}}) {
    return Container(
      height: height,
      width: 1200,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: units.map((unit) {
          bool isVacant = ['3-A', '3-C', '207호', '1-A', '1-C'].contains(unit);
          bool isSpecial = unit == '지하주차장' || unit == '옥탑층';
          return Expanded(
            flex: flexMap[unit] ?? 1,
            child: Container(
              decoration: BoxDecoration(
                color: (isVacant || isSpecial) ? Colors.pink[50] : Colors.white,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Center(
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: isVacant ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
