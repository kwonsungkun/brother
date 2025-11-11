// 1. 필요한 패키지 가져오기
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지
import 'dart:convert';                   // JSON 데이터를 Dart 객체로 변환하기 위한 패키지

void main() async { // 비동기(async)로 실행

  // 2. 데이터를 가져올 URL
  // (만약 안드로이드 에뮬레이터에서 테스트 중이라면,
  // 127.0.0.1이나 localhost 대신 10.0.2.2를 사용해야 합니다.)
  // (실제 기기라면 192.168.100.24가 동일 네트워크에 있어야 합니다.)
  var url = Uri.parse('http://192.168.100.24/test.php');

  try {
    // 3. HTTP GET 요청 보내기 (await: 응답이 올 때까지 기다림)
    var response = await http.get(url);

    // 4. 응답 상태 확인
    if (response.statusCode == 200) {
      // 5. 응답 본문(String)을 JSON으로 디코딩
      // response.body는 {"success":true,"data":[{"id":1,...}]} 형태의 문자열입니다.
      // jsonDecode는 이 문자열을 Dart의 Map/List 객체로 변환합니다.
      var jsonData = jsonDecode(response.body);

      // 6. 결과 출력
      print('--- 서버 응답 (JSON 디코딩됨) ---');
      print(jsonData);

      // "data" 키에 해당하는 값(리스트)만 따로 출력
      if (jsonData['success'] == true) {
        print('\n--- "data" 키의 값 ---');
        print(jsonData['data']);

        // 데이터 리스트를 순회하며 출력
        print('\n--- 데이터 항목별 출력 ---');
        var dataList = jsonData['data'] as List; // 리스트로 변환
        for (var item in dataList) {
          print('ID: ${item['id']}, 이름: ${item['username']}, 이메일: ${item['email']}');
        }

      } else {
        print('서버에서 데이터를 가져오는 데 실패했습니다: ${jsonData['message']}');
      }

    } else {
      // 200 OK가 아닌 경우 (예: 404 Not Found, 500 Server Error)
      print('서버 연결 실패: ${response.statusCode}');
    }
  } catch (e) {
    // 7. 예외 처리 (예: 인터넷 연결이 안 되거나, 서버 주소가 잘못된 경우)
    print('오류 발생: $e');
  }
}