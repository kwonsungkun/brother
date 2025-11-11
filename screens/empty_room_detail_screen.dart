import 'package:flutter/material.dart';

// 공실 상세 정보를 담는 데이터 모델 클래스
class EmptyRoomDetail {
  // 1. 기본 정보 및 현황
  final String propertyAddress;
  final String propertyType;
  final String vacancyStartDate;
  final String vacancyDuration;
  final String desiredLeaseCondition;
  final String previousLeaseCondition;

  // 2. 물건 상태 및 유지보수
  final String cleaningStatus;
  final String wallpaperStatus;
  final String mainOptions;
  final String repairHistory;
  final String lastInspectionDate;
  final String inspectionItems;
  final String actionTaken;
  final String periodicChecks;

  // 3. 공실 기간 중 비용 관리
  final String managementFee;
  final String utilityBills;
  final String otherCosts;
  final String totalCosts;

  // 4. 마케팅 및 임대 진행
  final String registeredAgencies;
  final String onlinePlatforms;
  final String adContent;
  final String showingHistory;
  final String inquiryStatus;
  final String leaseConditionChanges;

  // 5. 보안 및 안전
  final String doorLockInfo;
  final String securityChecks;

  const EmptyRoomDetail({
    required this.propertyAddress,
    required this.propertyType,
    required this.vacancyStartDate,
    required this.vacancyDuration,
    required this.desiredLeaseCondition,
    required this.previousLeaseCondition,
    required this.cleaningStatus,
    required this.wallpaperStatus,
    required this.mainOptions,
    required this.repairHistory,
    required this.lastInspectionDate,
    required this.inspectionItems,
    required this.actionTaken,
    required this.periodicChecks,
    required this.managementFee,
    required this.utilityBills,
    required this.otherCosts,
    required this.totalCosts,
    required this.registeredAgencies,
    required this.onlinePlatforms,
    required this.adContent,
    required this.showingHistory,
    required this.inquiryStatus,
    required this.leaseConditionChanges,
    required this.doorLockInfo,
    required this.securityChecks,
  });
}

class EmptyRoomDetailScreen extends StatelessWidget {
  final EmptyRoomDetail detail;

  const EmptyRoomDetailScreen({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.propertyAddress),
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
            _buildSection('1. 기본 정보 및 현황', [
              _buildDetailRow('공실 물건 주소', detail.propertyAddress),
              _buildDetailRow('물건 종류', detail.propertyType),
              _buildDetailRow('공실 발생일', detail.vacancyStartDate),
              _buildDetailRow('공실 기간', detail.vacancyDuration, isHighlighted: true),
              _buildDetailRow('희망 임대 조건', detail.desiredLeaseCondition),
              _buildDetailRow('이전 임대 조건', detail.previousLeaseCondition),
            ]),
            _buildSection('2. 물건 상태 및 유지보수', [
              _buildDetailRow('청소 상태', detail.cleaningStatus),
              _buildDetailRow('도배/장판 상태', detail.wallpaperStatus),
              _buildDetailRow('주요 옵션/시설물', detail.mainOptions),
              _buildDetailRow('수리/보수 이력', detail.repairHistory),
              _buildDetailRow('점검 날짜', detail.lastInspectionDate),
              _buildDetailRow('점검 항목', detail.inspectionItems),
              _buildDetailRow('조치 내용', detail.actionTaken),
              _buildDetailRow('정기 점검 항목', detail.periodicChecks),
            ]),
            _buildSection('3. 공실 기간 중 비용 관리', [
              _buildDetailRow('관리비', detail.managementFee),
              _buildDetailRow('공과금 (기본료)', detail.utilityBills),
              _buildDetailRow('기타 비용', detail.otherCosts),
              _buildDetailRow('누적 비용 합계', detail.totalCosts, isHighlighted: true),
            ]),
            _buildSection('4. 마케팅 및 임대 진행', [
              _buildDetailRow('매물 등록 중개사무소', detail.registeredAgencies),
              _buildDetailRow('온라인 플랫폼', detail.onlinePlatforms),
              _buildDetailRow('광고/홍보 내용', detail.adContent),
              _buildDetailRow('방문 이력 (Showing)', detail.showingHistory),
              _buildDetailRow('입주 문의 현황', detail.inquiryStatus),
              _buildDetailRow('임대 조건 변경 이력', detail.leaseConditionChanges),
            ]),
            _buildSection('5. 보안 및 안전', [
              _buildDetailRow('도어락/키 관리', detail.doorLockInfo),
              _buildDetailRow('보안 점검', detail.securityChecks),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.blueAccent : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
