import 'package:flutter/material.dart';
import 'package:project/screens/home_page.dart';

// 데이터 모델은 그대로 유지
class JobPosting {
  final String title;
  final String salary;
  final String workHours;
  final String details;
  final List<String> tags;
  final String imageUrl;

  const JobPosting({
    required this.title,
    required this.salary,
    required this.workHours,
    required this.details,
    required this.tags,
    required this.imageUrl,
  });
}

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  final List<JobPosting> _jobPostings = const [
    JobPosting(title: '운전만하세요. 힘든상황벗어나게 해준 꿀직장', salary: '월급 800만원', workHours: '월~금 ・ 09:00 ~ 20:00', details: '선경종합운수 ・ 물금읍', tags: ['후기 1'], imageUrl: ' '),
    JobPosting(title: '부산 본업으로 소화물 배송해 주실 기사님 모집...', salary: '월급 500만원', workHours: '월~토 ・ 08:00 ~ 16:00', details: '소화물배송 ・ 기장읍', tags: ['정직원'], imageUrl: ' '),
    JobPosting(title: '단순 포장 / 박스 테이핑 / 상하차 / 발송 보조', salary: '시급 10,030원', workHours: '총 3일 / 오늘~10월 30일 ・ 09:00 ~ 18:00', details: '말랑하니 ・ 장안읍', tags: ['모범구인', '후기 265'], imageUrl: ' '),
    JobPosting(title: '동부산롯데아울렛 미스카츠 홀정직원 구합니다', salary: '월급 300만원', workHours: '월,화,목,금,토,일 ・ 09:30 ~ 20:30', details: '미스카츠 ・ 기장읍', tags: ['모범구인', '정직원', '후기 78'], imageUrl: ' '),
  ];

  // 1. 화면 이동 함수 추가
  void _onItemTapped(BuildContext context, int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage(initialIndex: index)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('일자리 정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _jobPostings.length,
        itemBuilder: (context, index) {
          return _buildJobItem(_jobPostings[index]);
        },
      ),
      // 2. 네비게이션 바 추가
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
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildJobItem(JobPosting job) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(job.details, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text('${job.salary} / ${job.workHours}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
