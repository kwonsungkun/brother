import 'package:flutter/material.dart';

enum DepositStatus { imminent, returned, partiallyReturned }

class Unit {
  final String roomNumber, tenantName, expiryDate, deposit, rent, gender, contact, realty, notes, unpaidAmount;
  final String contractDate, area, moveInDate, entrancePassword, roomPassword;
  final bool isVacant;
  final bool hasAc, hasFridge, hasGasStove, hasWasher, hasTv, hasInternet, hasParking, hasElevator;
  final DepositStatus depositStatus;

  const Unit({
    required this.roomNumber, required this.tenantName, required this.isVacant,
    required this.expiryDate, required this.deposit, required this.rent, 
    required this.gender, required this.contact, required this.realty, 
    required this.notes, required this.contractDate, required this.unpaidAmount,
    required this.area, required this.moveInDate, required this.entrancePassword, required this.roomPassword,
    required this.hasAc, required this.hasFridge, required this.hasGasStove, required this.hasWasher, 
    required this.hasTv, required this.hasInternet, required this.hasParking, required this.hasElevator,
    required this.depositStatus,
  });
}

class Building {
  final String name, address;
  final int totalUnits, vacantUnits;
  final List<Unit> units;
  const Building({ required this.name, required this.address, required this.totalUnits, required this.vacantUnits, required this.units });
}
