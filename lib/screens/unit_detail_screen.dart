import 'package:flutter/material.dart';
import 'package:project/models/asset_models.dart';

class UnitDetailScreen extends StatelessWidget {
  final Unit unit;
  final Building building;

  const UnitDetailScreen({super.key, required this.unit, required this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${building.name} - ${unit.roomNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildDetailRow('임차인', unit.tenantName),
            _buildDetailRow('연락처', unit.contact),
            _buildDetailRow('만료일', unit.expiryDate),
            _buildDetailRow('보증금', unit.deposit),
            _buildDetailRow('월세', unit.rent),
            _buildDetailRow('면적', unit.area),
            _buildDetailRow('입주일', unit.moveInDate),
            _buildDetailRow('현관 비밀번호', unit.entrancePassword),
            _buildDetailRow('방 비밀번호', unit.roomPassword),
            _buildDetailRow('성별', unit.gender),
            _buildDetailRow('부동산', unit.realty),
            _buildDetailRow('메모', unit.notes),
            const Divider(height: 32),
            _buildAmenitiesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('편의시설', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildAmenityChip('에어컨', unit.hasAc),
            _buildAmenityChip('냉장고', unit.hasFridge),
            _buildAmenityChip('가스레인지', unit.hasGasStove),
            _buildAmenityChip('세탁기', unit.hasWasher),
            _buildAmenityChip('TV', unit.hasTv),
            _buildAmenityChip('인터넷', unit.hasInternet),
            _buildAmenityChip('주차장', unit.hasParking),
            _buildAmenityChip('엘리베이터', unit.hasElevator),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityChip(String name, bool isAvailable) {
    return Chip(
      avatar: Icon(Icons.check_circle, color: isAvailable ? Colors.green : Colors.grey),
      label: Text(name),
      backgroundColor: isAvailable ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
    );
  }
}
