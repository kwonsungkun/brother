import 'package:flutter/material.dart';
import 'package:project/models/asset_models.dart';

class DepositReturnScreen extends StatefulWidget {
  final List<Building> buildings;
  const DepositReturnScreen({super.key, required this.buildings});

  @override
  State<DepositReturnScreen> createState() => _DepositReturnScreenState();
}

class _DepositReturnScreenState extends State<DepositReturnScreen> {
  late List<Unit> _allItems;
  late List<Unit> _filteredItems;
  DepositStatus? _selectedStatus;
  String? _selectedBuilding;
  String _dateSortOrder = '최신순';
  List<String> _buildingNames = [];

  @override
  void initState() {
    super.initState();
    _allItems = widget.buildings.expand((b) => b.units).toList();
    _buildingNames = widget.buildings.map((e) => e.name).toSet().toList();
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Unit> tempItems = List.from(_allItems);

    if (_selectedStatus != null) {
      tempItems = tempItems.where((item) => item.depositStatus == _selectedStatus).toList();
    }

    if (_selectedBuilding != null) {
      tempItems = tempItems.where((item) => widget.buildings.firstWhere((b) => b.units.contains(item)).name == _selectedBuilding).toList();
    }

    tempItems.sort((a, b) {
       try {
        final dateA = DateTime.parse(a.expiryDate.replaceAll('년 ', '-').replaceAll('월 ', '-').replaceAll('일', ''));
        final dateB = DateTime.parse(b.expiryDate.replaceAll('년 ', '-').replaceAll('월 ', '-').replaceAll('일', ''));
        return _dateSortOrder == '최신순' ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      } catch (e) {
        return 0;
      }
    });

    setState(() {
      _filteredItems = tempItems;
    });
  }

  Widget _buildStatusChip(DepositStatus status) {
    String text;
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case DepositStatus.imminent:
        text = '임박';
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;
      case DepositStatus.returned:
        text = '반환됨';
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case DepositStatus.partiallyReturned:
        text = '부분반환';
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
    }

    return Chip(
      label: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      labelPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildFilterDropdown<T>({required String hint, required T? value, required List<DropdownMenuItem<T>> items, required void Function(T?) onChanged}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            hint: Text(hint),
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('보증금 반환 현황'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '임차인 또는 호수로 검색...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterDropdown<DepositStatus>(
                  hint: '상태',
                  value: _selectedStatus,
                  items: [const DropdownMenuItem(value: null, child: Text('전체')), ...DepositStatus.values.map((status) {
                    String text;
                    switch(status) {
                      case DepositStatus.imminent: text = '임박'; break;
                      case DepositStatus.returned: text = '반환됨'; break;
                      case DepositStatus.partiallyReturned: text = '부분반환'; break;
                    }
                    return DropdownMenuItem(value: status, child: Text(text));
                  })],
                  onChanged: (val) => setState(() { _selectedStatus = val; _applyFiltersAndSort(); }),
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown<String>(
                  hint: '날짜',
                  value: _dateSortOrder,
                  items: ['최신순', '과거순'].map((order) => DropdownMenuItem(value: order, child: Text(order))).toList(),
                  onChanged: (val) => setState(() { _dateSortOrder = val!; _applyFiltersAndSort(); }),
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown<String>(
                  hint: '건물',
                  value: _selectedBuilding,
                  items: [const DropdownMenuItem(value: null, child: Text('전체')), ..._buildingNames.map((b) => DropdownMenuItem(value: b, child: Text(b)))],
                  onChanged: (val) => setState(() { _selectedBuilding = val; _applyFiltersAndSort(); }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.roomNumber} - ${item.tenantName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(item.deposit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('계약 만료: ${item.expiryDate}', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusChip(item.depositStatus),
                            TextButton(
                              child: const Row(
                                children: [
                                  Text('상세보기'),
                                  Icon(Icons.arrow_forward_ios, size: 14),
                                ],
                              ),
                              onPressed: () {},
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
