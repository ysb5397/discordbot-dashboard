import 'package:dio/dio.dart';

// ⚠️ [주의] 로컬 서버 주소 설정
// Android 에뮬레이터: "http://10.0.2.2:5500"
// iOS 시뮬레이터 / 웹: "http://localhost:5500"
// 실제 배포된 서버: "https://your-koyeb-app.koyeb.app"
const String baseUrl = "http://localhost:5500";
const String adminSecret = "my_secret_key"; // [보안 취약] 실제 앱에선 사용자 입력으로 받아야 함

class ApiService {
  late final Dio _dio;
  String? _token;

  // 싱글톤 패턴 적용 (선택 사항이지만 추천)
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ));

    // [Interceptor] 요청 보낼 때마다 토큰 자동 주입 + 로그 출력
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        print("REQ[${options.method}] => PATH: ${options.path}");
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        print("ERR[${e.response?.statusCode}] => MSG: ${e.message}");
        return handler.next(e);
      },
    ));
  }

  // 로그인
  Future<bool> login() async {
    try {
      final response =
          await _dio.post('/api/login', data: {'secret': adminSecret});
      if (response.statusCode == 200) {
        _token = response.data['accessToken'];
        print("✅ 로그인 성공 (Token 확보)");
        return true;
      }
    } catch (e) {
      print("❌ 로그인 실패: $e");
    }
    return false;
  }

  // 데이터 조회 공통 헬퍼
  Future<dynamic> _fetchData(String endpoint) async {
    if (_token == null) {
      final success = await login();
      if (!success) throw Exception("Login Failed");
    }
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<Map<String, dynamic>> fetchStats() async =>
      await _fetchData('/api/dashboard/stats');
  Future<List<dynamic>> fetchLogs() async =>
      await _fetchData('/api/dashboard/logs');
  Future<List<dynamic>> fetchWhitelist() async =>
      await _fetchData('/api/dashboard/whitelist');
}

// 전역 접근을 위한 인스턴스
final apiService = ApiService();
