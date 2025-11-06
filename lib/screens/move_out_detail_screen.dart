import 'package:flutter/material.dart';

// 퇴실 예정자 상세 정보를 담는 데이터 모델
class MoveOutDetail {
  final String tenantName;
  final String propertyAddress;
  final String contractPeriod;
  final String moveOutDate; // 퇴실 예정일
  final String deposit;
  final String remainingDeposit; // 잔존 보증금 (핵심)
  final String lastUnpaidAmount; // 최종 미납액

  const MoveOutDetail({
    required this.tenantName,
    required this.propertyAddress,
    required this.contractPeriod,
    required this.moveOutDate,
    required this.deposit,
    required this.remainingDeposit,
    required this.lastUnpaidAmount,
  });
}

class MoveOutDetailScreen extends StatelessWidget {
  final MoveOutDetail detail;

  const MoveOutDetailScreen({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${detail.tenantName} (퇴실 예정)'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('계약 정보', [
              _buildDetailRow('임대 물건 주소', detail.propertyAddress),
              _buildDetailRow('계약 기간', detail.contractPeriod),
              _buildDetailRow('퇴실 예정일', detail.moveOutDate, isHighlighted: true),
            ]),
            _buildSection('보증금 정산 내역', [
              _buildDetailRow('최초 보증금', detail.deposit),
              _buildDetailRow('최종 미납액', detail.lastUnpaidAmount),
              const Divider(height: 24, thickness: 1),
              _buildDetailRow('잔존 보증금', detail.remainingDeposit, isHighlighted: true, isLarge: true),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false, bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isLarge ? 20 : 16,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.blueAccent : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
