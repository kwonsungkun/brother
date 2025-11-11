import 'package:flutter/material.dart';

class UnpaidDetail {
  final String propertyAddress, tenantName, tenantContact, contractPeriod, deposit, monthlyRent, managementFee, paymentTerms;
  final String unpaidMonths, unpaidItems, unpaidAmountForMonth, cumulativeUnpaidTotal, lateInterest, remainingDeposit;
  final int cumulativeUnpaidCount;

  const UnpaidDetail({
    required this.propertyAddress, required this.tenantName, required this.tenantContact, required this.contractPeriod, required this.deposit, required this.monthlyRent, required this.managementFee, required this.paymentTerms,
    required this.unpaidMonths, required this.unpaidItems, required this.unpaidAmountForMonth, required this.cumulativeUnpaidCount, required this.cumulativeUnpaidTotal, required this.lateInterest, required this.remainingDeposit,
  });
}

class UnpaidDetailScreen extends StatelessWidget {
  final UnpaidDetail detail;
  final bool showDepositSettlement; // 스위치 추가

  const UnpaidDetailScreen({super.key, required this.detail, this.showDepositSettlement = false}); // 기본값 false

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.tenantName),
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
            _buildSection('1. 임차인 및 계약 기본 정보', [
              _buildDetailRow('임대 물건 주소', detail.propertyAddress),
              _buildDetailRow('임차인 성명', detail.tenantName),
              _buildDetailRow('임차인 연락처', detail.tenantContact),
              _buildDetailRow('계약 기간', detail.contractPeriod),
              _buildDetailRow('보증금', detail.deposit),
              _buildDetailRow('월 임대료', detail.monthlyRent),
              _buildDetailRow('관리비', detail.managementFee),
              _buildDetailRow('납부 조건', detail.paymentTerms),
            ]),
            _buildSection('2. 미납 상세 내역', [
              _buildDetailRow('미납 월(회차)', detail.unpaidMonths, isHighlighted: true),
              _buildDetailRow('미납 항목', detail.unpaidItems),
              _buildDetailRow('미납 금액', detail.unpaidAmountForMonth),
              _buildDetailRow('누적 미납 횟수', '${detail.cumulativeUnpaidCount}회'),
              _buildDetailRow('연체 이자', detail.lateInterest),
            ]),
            if (showDepositSettlement)
              _buildSection('3. 보증금 정산 내역', [
                _buildDetailRow('최초 보증금', detail.deposit),
                _buildDetailRow('(-) 누적 미납 총액', detail.cumulativeUnpaidTotal, isHighlighted: true),
                const Divider(height: 24, thickness: 1),
                _buildDetailRow('(=) 잔존 보증금', detail.remainingDeposit, isHighlighted: true, isLarge: true),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Padding(padding: const EdgeInsets.only(top: 24.0, bottom: 8.0), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), Card(elevation: 2, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: children)))]);
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
          Expanded(child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: isLarge ? 20 : 16, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal, color: isHighlighted ? Colors.blueAccent : Colors.black87))),
        ],
      ),
    );
  }
}
