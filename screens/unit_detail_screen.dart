import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/annual_rent_summary_screen.dart';
import 'package:project/screens/asset_status_screen.dart';
import 'package:file_picker/file_picker.dart';

class DocumentItem {
  final String title;
  final IconData icon;
  final Color color;
  String status;

  DocumentItem({required this.title, required this.icon, required this.color, this.status = '업로드 안됨'});
}

class UnitDetailScreen extends StatefulWidget {
  final Unit unit;
  final Building building;

  const UnitDetailScreen({super.key, required this.unit, required this.building});

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  final List<DocumentItem> _documents = [
    DocumentItem(title: '임대차계약서', icon: Icons.description_outlined, color: Colors.blue.shade400),
    DocumentItem(title: '건축물대장', icon: Icons.business_outlined, color: Colors.green.shade400),
    DocumentItem(title: '등기부등본', icon: Icons.receipt_long_outlined, color: Colors.purple.shade400),
    DocumentItem(title: '전입세대열람원', icon: Icons.people_outline, color: Colors.orange.shade400),
  ];

  Future<void> _pickFile(DocumentItem doc) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        doc.status = result.files.single.name;
      });
    }
  }

  void _showTenantHistoryDetail(Map<String, String> tenant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${tenant['name']!} 상세 정보'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('계약기간', tenant['period']!),
                _buildDetailRow('보증금', tenant['deposit']!),
                _buildDetailRow('월세', tenant['rent']!),
                _buildDetailRow('연락처', tenant['contact']!),
                _buildDetailRow('중개부동산', tenant['realty']!),
                _buildDetailRow('특이사항', tenant['notes']!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _showPreviousTenants() {
    // 1. 더미 데이터에 연락처, 중개부동산 추가
    final List<Map<String, String>> previousTenants = [
      {'name': '홍길동', 'period': '2021.01.01 ~ 2023.01.01', 'deposit': '1억', 'rent': '150만원', 'contact': '010-1234-5678', 'realty': '행운부동산', 'notes': '계약 연장 후 퇴실'},
      {'name': '김영희', 'period': '2019.01.01 ~ 2021.01.01', 'deposit': '9천만원', 'rent': '140만원', 'contact': '010-8765-4321', 'realty': '미래부동산', 'notes': '-'},
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('${widget.unit.roomNumber} 이전 내역'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: previousTenants.length,
              itemBuilder: (context, index) {
                final tenant = previousTenants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(tenant['name']!),
                    subtitle: Text('계약기간: ${tenant['period']!}'),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      _showTenantHistoryDetail(tenant);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.building.name} ${widget.unit.roomNumber}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showPreviousTenants,
            tooltip: '이전 임차인 내역',
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection(
              '임차인 정보',
              [
                _buildDetailRow('이름', widget.unit.tenantName),
                _buildDetailRow('성별', widget.unit.gender),
                _buildDetailRow('연락처', widget.unit.contact),
              ],
            ),
            const SizedBox(height: 16),
            _buildContractSection(),
            const SizedBox(height: 16),
            _buildAttachmentSection(),
            const SizedBox(height: 16),
            _buildSection(
              '특이사항',
              [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(widget.unit.notes.isEmpty ? '특이사항 없음' : widget.unit.notes, style: const TextStyle(fontSize: 16, height: 1.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractSection() {
    return _buildSection(
      '계약 정보',
      [
        _buildDetailRow('계약일', widget.unit.contractDate),
        _buildDetailRow('만료일', widget.unit.expiryDate),
        _buildDetailRow('보증금', widget.unit.deposit),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('월 임대료', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              const SizedBox(width: 16),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: widget.unit.rent,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      if (!widget.unit.isVacant) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnnualRentSummaryScreen(unit: widget.unit, building: widget.building)));
                      }
                    },
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        _buildDetailRow('중개부동산', widget.unit.realty),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return _buildSection(
      '첨부 서류',
      _documents.map((doc) => _buildAttachmentRow(doc)).toList(),
    );
  }

  Widget _buildAttachmentRow(DocumentItem doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(doc.icon, color: doc.color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(doc.status, style: TextStyle(fontSize: 12, color: doc.status == '업로드 안됨' ? Colors.red : Colors.blueAccent)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _pickFile(doc),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('업로드'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const Divider(height: 1),
        Padding(padding: const EdgeInsets.all(16.0), child: Column(children: children)),
      ]),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
