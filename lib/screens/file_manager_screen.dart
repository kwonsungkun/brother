import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project/screens/home_page.dart';
import 'folder_detail_screen.dart';
import '../widgets/management_menu_widget.dart';
import '../services/ocr_service.dart'; // 통합 OCR 서비스 import

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  final List<String> _allFolders = ['등기부등본', '건축물대장', '임대차 계약서', '전입세대열람원', '기타'];
  late List<String> _filteredFolders;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredFolders = _allFolders;
    _searchController.addListener(_filterFolders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFolders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFolders = _allFolders.where((folder) => folder.toLowerCase().contains(query)).toList();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _uploadAndCategorizeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final fileName = result.files.single.name;
      final filePath = result.files.single.path;
      bool hasKeyword = false;

      if (!kIsWeb && filePath != null) {
        // OCR 서비스를 호출하여 키워드 확인 (모바일 전용)
        hasKeyword = await OcrService.performOcr(filePath);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('웹에서는 OCR 분석이 지원되지 않습니다.')),
          );
        }
      }
      
      final String targetFolder;
      if (fileName.contains('등기부등본')) {
        targetFolder = '등기부등본';
      } else if (fileName.contains('건축물대장')) {
        targetFolder = '건축물대장';
      } else if (fileName.contains('임대차')) {
        targetFolder = '임대차 계약서';
      } else if (fileName.contains('전입세대')) {
        targetFolder = '전입세대열람원';
      } else {
        targetFolder = '기타';
      }

      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('업로드 완료 (시뮬레이션)'),
              content: Text("'$fileName' 파일이 서버의 '$targetFolder' 폴더에 저장되었습니다."),
              actions: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }

      if (hasKeyword) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('완료'),
                content: const Text("문서에서 '결과보고서' 단어를 확인했습니다."),
                actions: [
                  TextButton(
                    child: const Text('확인'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      // User canceled the picker
    }
  }


  void _addFolder() {
    final folderNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('새 폴더 추가'),
          content: TextField(
            controller: folderNameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: '폴더 이름을 입력하세요'),
          ),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                if (folderNameController.text.isNotEmpty) {
                  setState(() {
                    _allFolders.add(folderNameController.text);
                    _filterFolders();
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: const Text('선택'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.create_new_folder_outlined),
                title: const Text('새 폴더 추가'),
                onTap: () {
                  Navigator.pop(context);
                  _addFolder();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('정렬 기준'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: _filteredFolders.length,
                itemBuilder: (context, index) {
                  final folderName = _filteredFolders[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FolderDetailScreen(folderName: folderName),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(Icons.folder, size: 60, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(folderName, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보'),
        ],
        currentIndex: 0, // 홈 탭 활성화
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '폴더 검색...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _searchController.clear();
              } else {
                _stopSearch();
              }
            },
          ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('폴더', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _uploadAndCategorizeFile),
          IconButton(icon: const Icon(Icons.search), onPressed: _startSearch),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: _showMoreOptions), // 아이콘 변경
        ],
      );
    }
  }
}
