import 'package:flutter/material.dart';
import 'package:project/screens/asset_status_screen.dart';

// 개인별 월세 납부 내역 데이터 모델
class PaymentRecord {
  final String paymentDate;
  final String amount;
  final String note;

  const PaymentRecord({required this.paymentDate, required this.amount, required this.note});
}

class RentHistoryScreen extends StatelessWidget {
  final Unit unit;
  final Building building;

  // 1. asset_status_screen에서 전달하는 unit, building을 받도록 생성자 복구
  const RentHistoryScreen({super.key, required this.unit, required this.building});

  // 개인별 납부 내역 더미 데이터
  final List<PaymentRecord> _paymentRecords = const [
    PaymentRecord(paymentDate: '2024-07-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2024-06-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2024-05-28', amount: '1,500,000원', note: '3일 지연 입금'),
    PaymentRecord(paymentDate: '2024-04-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2024-03-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2024-02-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2024-01-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2023-12-26', amount: '1,500,000원', note: '1일 지연 입금'),
    PaymentRecord(paymentDate: '2023-11-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2023-10-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2023-09-25', amount: '1,500,000원', note: '정상 입금'),
    PaymentRecord(paymentDate: '2023-08-25', amount: '1,500,000원', note: '정상 입금'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('${unit.roomNumber} 월세 장부'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            pinned: true,
            floating: true,
            // 2. 상단 고정 헤더에 요청하신 모든 정보가 표시되도록 UI 수정
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(96.0),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${building.name} ${unit.roomNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('임차인: ${unit.tenantName}'), Text('월세: ${unit.rent}')]),
                    const SizedBox(height: 4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('미납금: '), Text(unit.unpaidAmount, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final record = _paymentRecords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text('${record.paymentDate} 납부'),
                    subtitle: Text(record.note, style: TextStyle(color: record.note.contains('지연') ? Colors.red : Colors.grey)),
                    trailing: Text(record.amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                );
              },
              childCount: _paymentRecords.length,
            ),
          ),
        ],
      ),
    );
  }
}
