import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/asset_models.dart';

enum PaymentStatus { paid, unpaid, scheduled }

class MonthlyPayment {
  final int month;
  final PaymentStatus status;

  const MonthlyPayment({required this.month, required this.status});
}

class AnnualRentSummaryScreen extends StatefulWidget {
  final Unit unit;
  final Building building;
  final bool isDeposit;

  const AnnualRentSummaryScreen({
    super.key, 
    required this.unit, 
    required this.building,
    this.isDeposit = false,
  });

  @override
  State<AnnualRentSummaryScreen> createState() => _AnnualRentSummaryScreenState();
}

class _AnnualRentSummaryScreenState extends State<AnnualRentSummaryScreen> {
  late int _currentYear;

  final Map<int, List<MonthlyPayment>> _yearlyPayments = {
    2025: List.generate(12, (index) {
      if (index < 9) return MonthlyPayment(month: index + 1, status: PaymentStatus.paid);
      if (index == 9) return MonthlyPayment(month: index + 1, status: PaymentStatus.unpaid);
      return MonthlyPayment(month: index + 1, status: PaymentStatus.scheduled);
    }),
    2024: List.generate(12, (index) => MonthlyPayment(month: index + 1, status: PaymentStatus.paid)),
    2023: List.generate(12, (index) {
      if (index == 5) return MonthlyPayment(month: index + 1, status: PaymentStatus.unpaid);
      return MonthlyPayment(month: index + 1, status: PaymentStatus.paid);
    }),
  };

  @override
  void initState() {
    super.initState();
    _currentYear = 2025;
  }

  void _changeYear(int year) {
    setState(() {
      _currentYear += year;
    });
  }
  
  Widget _buildYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.arrow_left, size: 20), onPressed: () => _changeYear(-1)),
        Text('$_currentYear년', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        IconButton(icon: const Icon(Icons.arrow_right, size: 20), onPressed: () => _changeYear(1)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, size: 20), onPressed: () => Navigator.of(context).pop()),
        title: Text(widget.isDeposit ? '보증금 반환 현황' : '월세 납부 현황'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: widget.isDeposit
          ? _buildDepositBody()
          : _buildRentBody(),
    );
  }

  Widget _buildRentBody() {
    final rentString = widget.unit.rent;
    int monthlyRent = 0;
    if (rentString.isNotEmpty && rentString != '-') {
      try {
        if (rentString.contains('만')) {
          final numberPart = rentString.replaceAll(RegExp(r'[^0-9]'), '');
          monthlyRent = (int.parse(numberPart)) * 10000;
        }
      } catch (e) {
        monthlyRent = 0;
      }
    }

    final currentYearPayments = _yearlyPayments[_currentYear] ?? List.generate(12, (index) => MonthlyPayment(month: index+1, status: PaymentStatus.scheduled));

    final NumberFormat currencyFormat = NumberFormat('#,##0');
    final totalExpected = monthlyRent * 12;
    final paidCount = currentYearPayments.where((p) => p.status == PaymentStatus.paid).length;
    final unpaidCount = currentYearPayments.where((p) => p.status == PaymentStatus.unpaid).length;
    final totalPaid = paidCount * monthlyRent;
    final totalUnpaid = unpaidCount * monthlyRent;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildYearSelector(),
        const SizedBox(height: 16),
        _buildSummaryCard(currencyFormat, totalExpected, totalPaid, totalUnpaid),
        const SizedBox(height: 24),
        _buildMonthlyDetailSection(currentYearPayments),
      ],
    );
  }

  Widget _buildDepositBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${widget.building.name} ${widget.unit.roomNumber}', style: Theme.of(context).textTheme.headlineSmall), 
            const SizedBox(height: 8),
            Text('임차인: ${widget.unit.tenantName}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('보증금 반환 상태', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildStatusChip(widget.unit.depositStatus),
                    const SizedBox(height: 16),
                    Text('보증금: ${widget.unit.deposit}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
    );
  }

  Widget _buildSummaryCard(NumberFormat format, int expected, int paid, int unpaid) {
    return Card(
      elevation: 2, color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('연간 월세 요약'), Text('$_currentYear/01/01 ~ $_currentYear/12/31')]),
            const SizedBox(height: 16),
            _buildSummaryRow('총 월세 (예상)', '${format.format(expected)}원', Colors.black),
            const SizedBox(height: 8),
            _buildSummaryRow('총 입금액 (수입)', '+${format.format(paid)}원', Colors.blueAccent),
            const SizedBox(height: 8),
            _buildSummaryRow('총 미납액', '-${format.format(unpaid)}원', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildMonthlyDetailSection(List<MonthlyPayment> payments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$_currentYear년 월별 상세 내역 (${payments.length}건)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(
          elevation: 2, color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.building.name} ${widget.unit.roomNumber} - ${widget.unit.tenantName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('월세: ${widget.unit.rent}', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.5),
                  itemBuilder: (context, index) {
                    final payment = payments.firstWhere((p) => p.month == index + 1, orElse: () => MonthlyPayment(month: index + 1, status: PaymentStatus.scheduled));
                    return _buildMonthStatusChip(payment);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthStatusChip(MonthlyPayment payment) {
    Color backgroundColor, textColor;
    String statusText;
    switch (payment.status) {
      case PaymentStatus.paid:
        backgroundColor = Colors.green.withOpacity(0.1);
        statusText = '완납';
        textColor = Colors.green;
        break;
      case PaymentStatus.unpaid:
        backgroundColor = Colors.red.withOpacity(0.1);
        statusText = '미납';
        textColor = Colors.red;
        break;
      case PaymentStatus.scheduled:
        backgroundColor = Colors.grey.withOpacity(0.1);
        statusText = '예정';
        textColor = Colors.grey.shade700;
        break;
    }

    return Container(
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${payment.month}월'), Text(statusText, style: TextStyle(fontWeight: FontWeight.bold, color: textColor))]),
    );
  }
}
