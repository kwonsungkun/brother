import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';
import 'as_write_post_screen.dart';

// 1. 데이터 모델 및 열거형 정의
class ASPost {
  final String category, title, description, timestamp;
  String status;

  ASPost({
    required this.category,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.status,
  });
}

enum ASPostSortCriterion { category, timestamp, room }
enum SortOrder { ascending, descending }

class ASBoardScreen extends StatefulWidget {
  const ASBoardScreen({super.key});

  @override
  State<ASBoardScreen> createState() => _ASBoardScreenState();
}

class _ASBoardScreenState extends State<ASBoardScreen> {
  final List<ASPost> _allPosts = [
    ASPost(category: '수도/배관', title: '201호 - 화장실 세면대 막힘', description: '세면대에 물이 내려가지 않습니다. 확인 부탁드립니다.', timestamp: '2일 전', status: '처리 완료'),
    ASPost(category: '전기/조명', title: '503호 - 현관 센서등 고장', description: '현관 센서등이 계속 켜져 있습니다.', timestamp: '5일 전', status: '처리 완료'),
    ASPost(category: '기타', title: '주차장 입구 - 차단기 문제', description: '차단기가 올라가지 않습니다. 긴급 확인 요청합니다.', timestamp: '1시간 전', status: '접수 완료'),
  ];
  late List<ASPost> _filteredPosts;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isSelectionMode = false;
  final Set<ASPost> _selectedPosts = {};
  ASPostSortCriterion _sortCriterion = ASPostSortCriterion.timestamp;
  SortOrder _sortOrder = SortOrder.ascending; // 최신이 위로 오도록 오름차순

  @override
  void initState() {
    super.initState();
    _sortPosts();
    _filteredPosts = _allPosts;
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- 핵심 로직 --- 
  void _sortPosts() {
    int getTimeValue(String timestamp) {
      if (timestamp.contains('방금')) return 0;
      if (timestamp.contains('분')) return 1;
      if (timestamp.contains('시간')) return 2;
      if (timestamp.contains('일')) return 3;
      return 4;
    }

    _allPosts.sort((a, b) {
      int comparison;
      switch (_sortCriterion) {
        case ASPostSortCriterion.category:
          comparison = a.category.compareTo(b.category);
          break;
        case ASPostSortCriterion.timestamp:
          comparison = getTimeValue(a.timestamp).compareTo(getTimeValue(b.timestamp));
          if (comparison == 0) {
             final timeA = int.tryParse(a.timestamp.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
             final timeB = int.tryParse(b.timestamp.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
             comparison = timeA.compareTo(timeB);
          }
          break;
        case ASPostSortCriterion.room:
          final roomA = int.tryParse(RegExp(r'^(\d+)').firstMatch(a.title)?.group(1) ?? '0') ?? 0;
          final roomB = int.tryParse(RegExp(r'^(\d+)').firstMatch(b.title)?.group(1) ?? '0') ?? 0;
          comparison = roomA.compareTo(roomB);
          break;
      }
      return _sortOrder == SortOrder.ascending ? comparison : -comparison;
    });
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase(); // 오류 수정: query 변수 정의
    setState(() {
      _filteredPosts = _allPosts.where((post) {
        final title = post.title.toLowerCase();
        final content = post.description.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    });
  }

  void _addPost(Map<String, String> newPostData) {
    final rawTitle = newPostData['title'] ?? '';
    final categoryMatch = RegExp(r'\[(.*?)\]').firstMatch(rawTitle);
    final category = categoryMatch?.group(1) ?? '기타';
    final title = rawTitle.replaceFirst(RegExp(r'\[(.*?)\]\s*'), '');

    setState(() {
      _allPosts.insert(0, ASPost(category: category, title: title, description: newPostData['content'] ?? '', timestamp: '방금 전', status: '접수 완료'));
      _sortPosts();
      _filterPosts();
    });
  }
  
  void _showSortDialog() {
    ASPostSortCriterion tempCriterion = _sortCriterion;
    SortOrder tempOrder = _sortOrder;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정렬'),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), child: Text('순서', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                  RadioListTile<SortOrder>(title: const Text('오름차순'), value: SortOrder.ascending, groupValue: tempOrder, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempOrder = v!)),
                  RadioListTile<SortOrder>(title: const Text('내림차순'), value: SortOrder.descending, groupValue: tempOrder, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempOrder = v!)),
                  const Divider(),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), child: Text('정렬 기준', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent))),
                  RadioListTile<ASPostSortCriterion>(title: const Text('분류'), value: ASPostSortCriterion.category, groupValue: tempCriterion, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempCriterion = v!)),
                  RadioListTile<ASPostSortCriterion>(title: const Text('접수일'), value: ASPostSortCriterion.timestamp, groupValue: tempCriterion, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempCriterion = v!)),
                  RadioListTile<ASPostSortCriterion>(title: const Text('호실'), value: ASPostSortCriterion.room, groupValue: tempCriterion, activeColor: Colors.redAccent, onChanged: (v) => setState(() => tempCriterion = v!)),
                ]),
              );
            },
          ),
          actions: [
            TextButton(child: const Text('취소'), onPressed: () => Navigator.of(context).pop()),
            TextButton(child: const Text('저장'), onPressed: () {
                setState(() {
                  _sortCriterion = tempCriterion;
                  _sortOrder = tempOrder;
                  _sortPosts();
                  _filterPosts();
                });
                Navigator.of(context).pop();
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
          child: Wrap(children: <Widget>[
            ListTile(leading: const Icon(Icons.check_box_outline_blank), title: const Text('선택'), onTap: () { Navigator.pop(context); setState(() => _isSelectionMode = true); }),
            ListTile(leading: const Icon(Icons.sort), title: const Text('정렬 기준'), onTap: () { Navigator.pop(context); _showSortDialog(); }),
          ]),
        );
      },
    );
  }

  void _navigateToWriteScreen() async {
    final newPost = await Navigator.push(context, MaterialPageRoute(builder: (context) => const ASWritePostScreen()));
    if (newPost != null && newPost is Map<String, String>) _addPost(newPost);
  }
  void _startSearch() => setState(() => _isSearching = true);
  void _stopSearch() => setState(() { _isSearching = false; _searchController.clear(); });
  void _onItemTapped(int index) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)), (Route<dynamic> route) => false);
  void _updateSelectedPostsStatus() {
    setState(() {
      for (var post in _selectedPosts) { post.status = '처리 완료'; }
      _isSelectionMode = false;
      _selectedPosts.clear();
    });
  }
  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: const Text('상태 변경'), content: const Text('처리 완료로 변경하시겠습니까?'), actions: [
          TextButton(child: const Text('취소'), onPressed: () => Navigator.of(context).pop()),
          TextButton(child: const Text('확인'), onPressed: () { Navigator.of(context).pop(); _updateSelectedPostsStatus(); }),
        ]));
  }

  AppBar _buildAppBar() {
    if (_isSelectionMode) {
      return AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 1, leading: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() { _isSelectionMode = false; _selectedPosts.clear(); })), title: Text('${_selectedPosts.length}개 선택'), actions: [IconButton(icon: const Icon(Icons.check), onPressed: _selectedPosts.isNotEmpty ? _showStatusUpdateDialog : null)]);
    }
    return AppBar(title: const Text('A/S 게시판'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0, actions: [IconButton(icon: const Icon(Icons.search), onPressed: _startSearch, tooltip: '검색'), IconButton(icon: const Icon(Icons.add), onPressed: _navigateToWriteScreen, tooltip: '글쓰기'), IconButton(icon: const Icon(Icons.more_vert), onPressed: _showMoreOptions, tooltip: '더보기')]);
  }

  Widget _buildPostItem(ASPost post) {
    final isSelected = _selectedPosts.contains(post);
    final statusColor = post.status == '처리 완료' ? Colors.green.shade700 : Colors.orange.shade700;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () { if (_isSelectionMode) setState(() { if (isSelected) { _selectedPosts.remove(post); } else { _selectedPosts.add(post); }}); },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (_isSelectionMode) ...[Checkbox(value: isSelected, onChanged: (val) => setState(() { if (val!) _selectedPosts.add(post); else _selectedPosts.remove(post); })), const SizedBox(width: 8)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Chip(label: Text(post.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.blue.shade300, padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap), Text(post.timestamp, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))]),
                    const SizedBox(height: 12),
                    Text(post.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(post.description, style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
                    const Divider(height: 32),
                    Text(post.status, style: TextStyle(fontSize: 14, color: statusColor, fontWeight: FontWeight.bold)),
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _filteredPosts.isEmpty ? Center(child: Text(_allPosts.isEmpty ? '게시글이 없습니다.' : '검색 결과가 없습니다.', style: const TextStyle(fontSize: 18, color: Colors.grey))) : ListView.builder(itemCount: _filteredPosts.length, itemBuilder: (context, index) => _buildPostItem(_filteredPosts[index])),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'), BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: '캐쉬'), BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '상품'), BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'), BottomNavigationBarItem(icon: Icon(Icons.campaign), label: '내집홍보')], currentIndex: 3, selectedItemColor: Colors.blueAccent, unselectedItemColor: Colors.grey, onTap: _onItemTapped, type: BottomNavigationBarType.fixed),
    );
  }
}
