import 'package:flutter/material.dart';
import '../widgets/management_menu_widget.dart';

class FolderDetailScreen extends StatefulWidget {
  final String folderName;

  const FolderDetailScreen({super.key, required this.folderName});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  final List<String> _allFiles = [];
  late List<String> _filteredFiles;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filteredFiles = _allFiles;
    _searchController.addListener(_filterFiles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFiles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFiles = _allFiles.where((file) => file.toLowerCase().contains(query)).toList();
    });
  }

  void _uploadFile() {
    setState(() {
      final newFile = '새로운 문서 ${_allFiles.length + 1}.pdf';
      _allFiles.add(newFile);
      _filterFiles();
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
                leading: const Icon(Icons.upload_file),
                title: const Text('업로드'),
                onTap: () {
                  Navigator.pop(context);
                  _uploadFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort),
                title: const Text('정렬 기준'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('업로드 요청 링크'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _filteredFiles.isEmpty
                ? const Center(
                    child: Text(
                      '업로드된 파일이 없습니다.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredFiles.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file, color: Colors.grey),
                          title: Text(_filteredFiles[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
          decoration: const InputDecoration(hintText: '파일 검색...', border: InputBorder.none),
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
        title: Text(widget.folderName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _uploadFile,
            tooltip: '파일 업로드',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _startSearch,
            tooltip: '파일 검색',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreOptions,
          ),
        ],
      );
    }
  }
}
