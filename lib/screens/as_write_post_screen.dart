import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ASWritePostScreen extends StatefulWidget {
  const ASWritePostScreen({super.key});

  @override
  State<ASWritePostScreen> createState() => _ASWritePostScreenState();
}

class _ASWritePostScreenState extends State<ASWritePostScreen> {
  final _roomInfoController = TextEditingController();
  final _contentController = TextEditingController();
  String? _selectedCategory;
  String? _selectedFileName;

  final List<String> _categories = ['누수', '전기', '파손', '기타'];

  void _submitRequest() {
    if (_roomInfoController.text.isNotEmpty && _selectedCategory != null && _contentController.text.isNotEmpty) {
      final title = '[${_selectedCategory!}] ${_roomInfoController.text}';
      final content = _contentController.text;
      
      final newPost = {
        'title': title,
        'content': content,
      };
      Navigator.pop(context, newPost);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('A/S 요청', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(label: '호실 정보', controller: _roomInfoController, hint: '예: 101호, 203동 502호'),
            const SizedBox(height: 24),
            _buildDropdownField(),
            const SizedBox(height: 24),
            _buildTextField(label: '상세 내용', controller: _contentController, hint: '문제가 되는 부분을 자세히 적어주세요.', maxLines: 5),
            const SizedBox(height: 24),
            _buildFilePicker(),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A4C9C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('요청 제출하기', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('요청 분류', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          hint: const Text('분류를 선택하세요'),
          items: _categories.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: (val) => setState(() => _selectedCategory = val),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('사진 첨부 (선택)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              child: const Text('파일 선택'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_selectedFileName ?? '선택된 파일 없음', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700])),
            ),
          ],
        )
      ],
    );
  }
}
