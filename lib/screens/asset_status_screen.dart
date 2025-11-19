import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/services/ocr_service.dart' if (dart.library.html) 'package:project/services/ocr_service_web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project/screens/file_manager_screen.dart';
import 'package:project/screens/unit_detail_screen.dart';
import 'package:project/screens/home_page.dart';
import 'package:project/screens/annual_rent_summary_screen.dart';
import 'package:project/screens/deposit_return_screen.dart';
import 'package:project/models/asset_models.dart';

class AssetStatusScreen extends StatefulWidget {
  final String? buildingName;
  const AssetStatusScreen({super.key, this.buildingName});

  @override
  State<AssetStatusScreen> createState() => _AssetStatusScreenState();
}

class _AssetStatusScreenState extends State<AssetStatusScreen> {
  int _selectedBuildingIndex = 0;
  late ScrollController _scrollController;
  bool _isLandscape = false;

  final List<Building> _buildings = [
    Building(
      name: '강남 럭키빌딩', address: '서울시 강남구 테헤란로 123', totalUnits: 15, vacantUnits: 1,
      units: [
        const Unit(roomNumber: '101호', tenantName: '김철수', isVacant: false, expiryDate: '2025-10-31', deposit: '1억', rent: '150만원', gender: '남성', contact: '010-1111-2222', realty: '강남부동산', notes: '애완동물(강아지) 키움.', contractDate: '2023-11-01', unpaidAmount: '0원', area: '25평', moveInDate: '2023-11-01', entrancePassword: '*1234#', roomPassword: '#5678', hasAc: true, hasFridge: true, hasGasStove: true, hasWasher: true, hasTv: true, hasInternet: true, hasParking: false, hasElevator: true, depositStatus: DepositStatus.imminent),
        const Unit(roomNumber: '102호', tenantName: '-', isVacant: true, expiryDate: '-', deposit: '-', rent: '-', gender: '-', contact: '-', realty: '-', notes: '도배, 장판 새로 완료.', contractDate: '-', unpaidAmount: '0원', area: '25평', moveInDate: '-', entrancePassword: '*0000#', roomPassword: '#9999', hasAc: true, hasFridge: true, hasGasStove: true, hasWasher: true, hasTv: false, hasInternet: true, hasParking: false, hasElevator: true, depositStatus: DepositStatus.returned),
        const Unit(roomNumber: '201호', tenantName: '이영희', isVacant: false, expiryDate: '2025-03-15', deposit: '1.2억', rent: '160만원', gender: '여성', contact: '010-3333-4444', realty: '강남부동산', notes: '-', contractDate: '2023-03-16', unpaidAmount: '160만원', area: '28평', moveInDate: '2023-03-16', entrancePassword: '#5678*', roomPassword: '#1212', hasAc: true, hasFridge: true, hasGasStove: true, hasWasher: true, hasTv: true, hasInternet: true, hasParking: false, hasElevator: true, depositStatus: DepositStatus.partiallyReturned),
        const Unit(roomNumber: '202호', tenantName: '박지민', isVacant: false, expiryDate: '2026-01-20', deposit: '1억', rent: '155만원', gender: '남성', contact: '010-5555-6666', realty: '삼성부동산', notes: '-', contractDate: '2024-01-21', unpaidAmount: '0원', area: '25평', moveInDate: '2024-01-21', entrancePassword: '#1122*', roomPassword: '#3434', hasAc: true, hasFridge: true, hasGasStove: false, hasWasher: true, hasTv: true, hasInternet: true, hasParking: false, hasElevator: true, depositStatus: DepositStatus.imminent),
        const Unit(roomNumber: '301호', tenantName: '최유나', isVacant: false, expiryDate: '2024-12-10', deposit: '5천만원', rent: '120만원', gender: '여성', contact: '010-7777-8888', realty: '강남부동산', notes: '-', contractDate: '2022-12-11', unpaidAmount: '0원', area: '22평', moveInDate: '2022-12-11', entrancePassword: '#3344*', roomPassword: '#7878', hasAc: true, hasFridge: true, hasGasStove: true, hasWasher: true, hasTv: false, hasInternet: true, hasParking: false, hasElevator: true, depositStatus: DepositStatus.imminent),
      ]
    ),
    const Building(name: '골든파크빌', address: '부산광역시 서구 아미동2가 19-8', totalUnits: 8, vacantUnits: 1, units: [
       Unit(roomNumber: '708호', tenantName: '홍길동', isVacant: false, expiryDate: '2025-05-10', deposit: '1억', rent: '100만원', gender: '남성', contact: '010-9999-8888', realty: '부산부동산', notes: '-', contractDate: '2023-05-11', unpaidAmount: '500,000원', area: '30평', moveInDate: '2023-05-11', entrancePassword: '*9988#', roomPassword: '#1234', hasAc: true, hasFridge: true, hasGasStove: true, hasWasher: true, hasTv: true, hasInternet: true, hasParking: true, hasElevator: true, depositStatus: DepositStatus.imminent),
       Unit(roomNumber: '303호', tenantName: '김영희', isVacant: false, expiryDate: '2024-11-20', deposit: '5천만원', rent: '80만원', gender: '여성', contact: '010-1111-3333', realty: '부산부동산', notes: '-', contractDate: '2022-11-21', unpaidAmount: '470,000원', area: '18평', moveInDate: '2022-11-21', entrancePassword: '*1133#', roomPassword: '#5678', hasAc: true, hasFridge: true, hasGasStove: false, hasWasher: true, hasTv: false, hasInternet: true, hasParking: true, hasElevator: true, depositStatus: DepositStatus.imminent),
       Unit(roomNumber: '201호', tenantName: '박철수', isVacant: false, expiryDate: '2025-09-01', deposit: '8천만원', rent: '90만원', gender: '남성', contact: '010-4444-5555', realty: '부산부동산', notes: '-', contractDate: '2023-09-02', unpaidAmount: '450,000원', area: '20평', moveInDate: '2023-09-02', entrancePassword: '*4455#', roomPassword: '#9012', hasAc: true, hasFridge: true, hasGasStove: true, hasWasher: true, hasTv: true, hasInternet: false, hasParking: true, hasElevator: true, depositStatus: DepositStatus.imminent),
    ]),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.buildingName != null) {
      final index = _buildings.indexWhere((b) => b.name == widget.buildingName);
      if (index != -1) {
        _selectedBuildingIndex = index;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollToIndex(index);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _scrollToIndex(int index) {
    const double itemWidth = 200.0;
    const double spacing = 12.0;
    final double scrollPosition = index * (itemWidth + spacing);
    _scrollController.animateTo(scrollPosition, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('전화 앱을 열 수 없습니다: $phoneNumber')),
        );
      }
    }
  }

  Future<void> _addAssetFromOcr() async {
    Navigator.pop(context);

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이미지 선택이 취소되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final String path = image.path;

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    bool ocrSuccess = await OcrService.performOcr(path);

    if (!mounted) return;
    Navigator.pop(context);

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ocrSuccess ? 'OCR 성공' : 'OCR 실패'),
            content: Text(ocrSuccess ? '이미지에서 "결과보고서"를 찾았습니다.' : '이미지에서 "결과보고서"를 찾지 못했습니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showAssetMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(children: <Widget>[
            ListTile(leading: const Icon(Icons.folder_copy_outlined), title: const Text('파일 관리'), onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FileManagerScreen()));
            }),
            ListTile(leading: const Icon(Icons.add_business_outlined), title: const Text('자산추가'), onTap: _addAssetFromOcr),
            ListTile(leading: const Icon(Icons.person_add_alt_1_outlined), title: const Text('임차인등록'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.edit_outlined), title: const Text('자산수정'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.edit_note_outlined), title: const Text('임대인수정'), onTap: () => Navigator.pop(context)),
          ]),
        );
      },
    );
  }

  void _showRealEstateNotificationDialog(BuildContext context, Unit unit) {
    final List<String> realEstateAgencies = _buildings.expand((b) => b.units).map((u) => u.realty).where((r) => r.isNotEmpty && r != '-').toSet().toList();
    final Set<String> selectedAgencies = {};

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${unit.roomNumber} 공실 알림'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: realEstateAgencies.length,
                  itemBuilder: (context, index) {
                    final agency = realEstateAgencies[index];
                    return CheckboxListTile(
                      title: Text(agency),
                      value: selectedAgencies.contains(agency),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedAgencies.add(agency);
                          } else {
                            selectedAgencies.remove(agency);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('보내기'),
                  onPressed: selectedAgencies.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${selectedAgencies.length}곳의 부동산에 알림을 보냈습니다.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedBuilding = _buildings[_selectedBuildingIndex];
    final textTheme = Theme.of(context).textTheme;
    final double textScaleFactor = _isLandscape ? 1.2 : 1.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buildingName == null ? '장부관리' : '장부관리 (${widget.buildingName!})', style: TextStyle(fontSize: 18 * textScaleFactor)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.screen_rotation),
            tooltip: '가로로 보기',
            onPressed: () {
              setState(() {
                _isLandscape = !_isLandscape;
                if (_isLandscape) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                }
              });
            },
          ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: _showAssetMoreOptions, tooltip: '더보기'),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.buildingName == null) ...[
              _buildBuildingSelectionSection(textScaleFactor),
              const SizedBox(height: 24),
            ],
            _buildUnitStatusSection(textScaleFactor)
          ]
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildBuildingSelectionSection(double textScaleFactor) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('보유 건물 현황', style: TextStyle(fontSize: 18 * textScaleFactor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: _selectedBuildingIndex > 0 ? () { final newIndex = _selectedBuildingIndex - 1; setState(() => _selectedBuildingIndex = newIndex); _scrollToIndex(newIndex); } : null),
          Expanded(child: SizedBox(height: 100 * textScaleFactor, child: ListView.separated(controller: _scrollController, scrollDirection: Axis.horizontal, itemCount: _buildings.length, separatorBuilder: (context, index) => const SizedBox(width: 12), itemBuilder: (context, index) { final building = _buildings[index]; final isSelected = index == _selectedBuildingIndex; return InkWell(onTap: () { setState(() => _selectedBuildingIndex = index); _scrollToIndex(index); }, child: Card(elevation: 2, color: isSelected ? Colors.blue.shade50 : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isSelected ? BorderSide(color: Colors.blue.shade300, width: 2) : BorderSide.none), child: Container(width: 200 * textScaleFactor, padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(building.name, style: TextStyle(fontSize: 16 * textScaleFactor, fontWeight: FontWeight.bold)), const Spacer(), Text(building.address, style: TextStyle(fontSize: 12 * textScaleFactor, color: Colors.grey[600]), overflow: TextOverflow.ellipsis),
            Text.rich(TextSpan(style: TextStyle(fontSize: 12 * textScaleFactor, color: Colors.grey[600]), children: [const TextSpan(text: '총 '), TextSpan(text: '${building.totalUnits}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)), const TextSpan(text: '호실 / 공실 '), TextSpan(text: '${building.vacantUnits}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))]))
            ])))); },))),
          IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: _selectedBuildingIndex < _buildings.length - 1 ? () { final newIndex = _selectedBuildingIndex + 1; setState(() => _selectedBuildingIndex = newIndex); _scrollToIndex(newIndex); } : null)
        ])
      ]);
  }

  Widget _buildAmenityIcon(IconData icon, bool isAvailable, String name, double textScaleFactor) {
    return Tooltip(
      message: name,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          icon,
          size: 20 * textScaleFactor,
          color: isAvailable ? Colors.grey[700] : Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildUnitStatusSection(double textScaleFactor) {
    final selectedBuilding = _buildings[_selectedBuildingIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${selectedBuilding.name} - 호실 현황 (${selectedBuilding.units.length}개)', style: TextStyle(fontSize: 18 * textScaleFactor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedBuilding.units.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final unit = selectedBuilding.units[index];
            final statusColor = unit.isVacant ? Colors.red : Colors.green;

            IconData genderIcon;
            Color? genderColor;
            if (unit.gender == '남성') {
              genderIcon = Icons.male;
              genderColor = Colors.blueAccent;
            } else if (unit.gender == '여성') {
              genderIcon = Icons.female;
              genderColor = Colors.pinkAccent;
            } else {
              genderIcon = Icons.person_outline;
            }

            return Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(unit.roomNumber, style: TextStyle(fontSize: 20 * textScaleFactor, fontWeight: FontWeight.bold, color: statusColor)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Material(type: MaterialType.transparency, child: IconButton(icon: Icon(Icons.info_outline, size: 20 * textScaleFactor), visualDensity: VisualDensity.compact, tooltip: '상세보기', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UnitDetailScreen(unit: unit, building: selectedBuilding))))),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Material(type: MaterialType.transparency, child: IconButton(icon: Icon(Icons.campaign, size: 20 * textScaleFactor), visualDensity: VisualDensity.compact, tooltip: '부동산에 공실 알림', onPressed: () => _showRealEstateNotificationDialog(context, unit))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Table(
                      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
                      children: [
                        TableRow(
                          children: [
                            _buildInfoCell(genderIcon, unit.tenantName, textScaleFactor, color: genderColor),
                            _buildClickableInfoCell(Icons.phone_iphone_outlined, unit.contact, () => _makePhoneCall(unit.contact), textScaleFactor),
                          ]
                        ),
                        TableRow(
                          children: [
                            _buildInfoCell(Icons.event_available_outlined, unit.moveInDate, textScaleFactor),
                            _buildInfoCell(Icons.date_range_outlined, unit.expiryDate, textScaleFactor),
                          ]
                        ),
                        TableRow(
                          children: [
                            _buildClickableDepositCell(unit, selectedBuilding, textScaleFactor),
                            _buildInfoCell(Icons.square_foot_outlined, unit.area, textScaleFactor),
                          ]
                        ),
                        TableRow(
                          children: [
                            _buildInfoCell(Icons.sensor_door_outlined, unit.roomPassword, textScaleFactor),
                            _buildInfoCell(Icons.vpn_key_outlined, unit.entrancePassword, textScaleFactor),
                          ]
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                     Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: [
                        _buildAmenityIcon(Icons.ac_unit, unit.hasAc, '에어컨', textScaleFactor),
                        _buildAmenityIcon(Icons.kitchen, unit.hasFridge, '냉장고', textScaleFactor),
                        _buildAmenityIcon(Icons.local_fire_department, unit.hasGasStove, '가스레인지', textScaleFactor),
                        _buildAmenityIcon(Icons.local_laundry_service, unit.hasWasher, '세탁기', textScaleFactor),
                        _buildAmenityIcon(Icons.tv, unit.hasTv, 'TV', textScaleFactor),
                        _buildAmenityIcon(Icons.wifi, unit.hasInternet, '인터넷', textScaleFactor),
                        _buildAmenityIcon(Icons.local_parking, unit.hasParking, '주차장', textScaleFactor),
                        _buildAmenityIcon(Icons.elevator, unit.hasElevator, '엘리베이터', textScaleFactor),
                      ],
                    ),
                  ],
                ),
              )
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoCell(IconData icon, String text, double textScaleFactor, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16 * textScaleFactor, color: color ?? Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13 * textScaleFactor), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableInfoCell(IconData icon, String text, VoidCallback onTap, double textScaleFactor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: (text.isNotEmpty && text != '-') ? onTap : null,
        child: Row(
          children: [
            Icon(icon, size: 16 * textScaleFactor, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: (text.isNotEmpty && text != '-') ? Colors.blue : Colors.black,
                  decoration: (text.isNotEmpty && text != '-') ? TextDecoration.underline : TextDecoration.none,
                  fontSize: 13 * textScaleFactor
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableDepositCell(Unit unit, Building building, double textScaleFactor) {
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.attach_money_outlined, size: 16 * textScaleFactor, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 13 * textScaleFactor, color: Colors.black),
                children: [
                  TextSpan(
                    text: '${unit.deposit} ',
                      style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DepositReturnScreen(buildings: _buildings),
                          ),
                        );
                      },
                  ),
                  const TextSpan(text: '/ '),
                  TextSpan(
                    text: unit.rent,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnualRentSummaryScreen(
                              unit: unit,
                              building: building,
                            ),
                          ),
                        );
                      },
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
