import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BotAdminApp());
}

// --- 1. 앱 테마 설정 (Discord Dark Theme) ---
class BotAdminApp extends StatelessWidget {
  const BotAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discord Bot Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF36393f), // 메인 배경색
        cardColor: const Color(0xFF2f3136), // 카드 배경색
        canvasColor: const Color(0xFF202225), // 사이드바 배경색
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5865F2), // Discord Blurple
          secondary: Color(0xFF3BA55C), // Discord Green
          surface: Color(0xFF2f3136),
          error: Color(0xFFED4245),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFdcddde)),
          titleLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // 스크롤바 테마 커스텀
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(const Color(0xFF202225)),
          trackColor: WidgetStateProperty.all(const Color(0xFF2f3136)),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// --- 2. 메인 스크린 (반응형 레이아웃 처리) ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = ["대시보드", "시스템 로그", "스케줄러", "화이트리스트", "설정 & API"];

  @override
  Widget build(BuildContext context) {
    // 화면 너비에 따라 레이아웃 결정 (800px 기준)
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      // 모바일일 때만 햄버거 메뉴(Drawer) 활성화
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: const Color(0xFF2f3136),
              title: Text(_titles[_selectedIndex]),
              elevation: 0,
            )
          : null,
      drawer: !isDesktop
          ? Drawer(
              child: _buildSidebarContent(),
            )
          : null,
      body: Row(
        children: [
          // 데스크톱일 때 왼쪽 사이드바 표시
          if (isDesktop)
            SizedBox(
              width: 250,
              child: _buildSidebarContent(),
            ),

          // 메인 컨텐츠 영역
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _buildDesktopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 사이드바 컨텐츠 (Drawer와 Desktop 사이드바 공용)
  Widget _buildSidebarContent() {
    return Container(
      color: const Color(0xFF202225),
      child: Column(
        children: [
          // 로고 영역
          Container(
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF2f3136))),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smart_toy, color: Color(0xFF5865F2), size: 28),
                SizedBox(width: 12),
                Text(
                  "Bot Admin",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          // 네비게이션 메뉴
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              children: [
                _navItem(0, Icons.dashboard, "대시보드"),
                _navItem(1, Icons.description, "시스템 로그"),
                _navItem(2, Icons.schedule, "스케줄러"),
                _navItem(3, Icons.people, "화이트리스트"),
                _navItem(4, Icons.settings, "설정 & API"),
              ],
            ),
          ),
          // 관리자 프로필 영역
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF2f3136))),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("관리자",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text("Online",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: isSelected ? const Color(0xFF40444b) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          setState(() => _selectedIndex = index);
          if (!MediaQuery.of(context).size.width.isFinite) {
            // Drawer 닫기 (모바일)
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // 데스크톱 상단 헤더
  Widget _buildDesktopHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF2f3136),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("Bot Admin",
                  style: TextStyle(color: Color(0xFF5865F2))),
              const SizedBox(width: 8),
              const Text("/", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              Text(_titles[_selectedIndex],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.green),
                    SizedBox(width: 8),
                    Text("System Healthy",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  // --- 3. 탭별 메인 컨텐츠 ---
  Widget _buildMainContent() {
    // 예시로 대시보드와 로그 탭만 구현 (나머지는 플레이스홀더)
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildLogsTab();
      case 2:
        return _buildSchedulerTab();
      default:
        return Center(
            child: Text("${_titles[_selectedIndex]} 화면 준비 중...",
                style: const TextStyle(fontSize: 20)));
    }
  }

  Widget _buildDashboardTab() {
    // 반응형 그리드 (화면 넓으면 4개, 좁으면 1~2개)
    final width = MediaQuery.of(context).size.width;
    int gridCrossAxisCount = width > 1200 ? 4 : (width > 800 ? 2 : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 통계 카드 그리드
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: gridCrossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8, // 카드 비율
          children: const [
            StatCard(
                title: "Total Interactions",
                value: "1,284",
                icon: Icons.chat_bubble,
                color: Color(0xFF5865F2),
                subText: "+12.5% 이번 주"),
            StatCard(
                title: "Gemini Token Usage",
                value: "84,392",
                icon: Icons.psychology,
                color: Colors.pinkAccent,
                subText: "Limit: 1M (8.4%)"),
            StatCard(
                title: "Pending Errors",
                value: "2",
                icon: Icons.warning_amber,
                color: Colors.amber,
                subText: "확인 필요",
                isAlert: true),
            StatCard(
                title: "Bot Uptime",
                value: "4d 12h",
                icon: Icons.timer,
                color: Colors.green,
                subText: "Last restart: Mon"),
          ],
        ),
        const SizedBox(height: 24),

        // 차트 및 서버 상태 섹션
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: MockChartCard(), // 외부 라이브러리 없이 만든 모의 차트
            ),
            SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: ServerStatusCard(),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildLogsTab() {
    return Card(
      color: const Color(0xFF2f3136),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("시스템 로그",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("새로고침"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5865F2),
                      foregroundColor: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 16),
            const LogItem(
                level: "ERROR",
                time: "12:42:01",
                source: "ai_helper.js",
                message: "Gemini API Timeout (5000ms)"),
            const Divider(color: Colors.grey),
            const LogItem(
                level: "INFO",
                time: "12:40:15",
                source: "watch_voice.js",
                message: "User 'ysb5397' joined voice channel"),
            const Divider(color: Colors.grey),
            const LogItem(
                level: "WARN",
                time: "12:38:55",
                source: "watch_chat.js",
                message: "Malicious URL detected and removed"),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulerTab() {
    return const Column(
      children: [
        SchedulerCard(
            title: "지진 감지 (Earthquake)",
            icon: Icons.public,
            color: Colors.red,
            interval: "60"),
        SizedBox(height: 16),
        SchedulerCard(
            title: "일일 브리핑 (Briefing)",
            icon: Icons.newspaper,
            color: Colors.blue,
            interval: "매일 08:30"),
      ],
    );
  }
}

// --- 4. 커스텀 위젯 모음 ---

// 통계 카드
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subText;
  final bool isAlert;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subText,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2f3136),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              )
            ],
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isAlert ? Colors.amber : Colors.white)),
          Text(subText,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// 모의 차트 (외부 라이브러리 없이 시각화)
class MockChartCard extends StatelessWidget {
  const MockChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2f3136),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("📊 주간 AI 호출량",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar("Mon", 0.6),
                _buildBar("Tue", 0.5),
                _buildBar("Wed", 0.8),
                _buildBar("Thu", 0.85),
                _buildBar("Fri", 0.55),
                _buildBar("Sat", 0.9),
                _buildBar("Sun", 1.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double pct) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 150 * pct, // 높이 조절
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5865F2), Color(0xFF404EED)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

// 서버 상태 카드
class ServerStatusCard extends StatelessWidget {
  const ServerStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2f3136),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("⚡ 서버 상태",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 24),
          _buildProgress("CPU Usage", 0.12, Colors.green),
          const SizedBox(height: 16),
          _buildProgress("Memory (RAM)", 0.64, Colors.amber),
          const SizedBox(height: 16),
          _buildProgress("API Latency", 0.2, Colors.blue),
          const Spacer(),
          const Divider(color: Colors.grey),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.multitrack_audio, color: Colors.redAccent, size: 16),
              SizedBox(width: 8),
              Text("일반 Music: 1 User", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.mic, color: Colors.blueAccent, size: 16),
              SizedBox(width: 8),
              Text("Gemini Live: 0 User",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(String label, double value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text("${(value * 100).toInt()}%",
                style: TextStyle(
                    fontSize: 12, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFF202225),
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}

// 로그 아이템
class LogItem extends StatelessWidget {
  final String level;
  final String time;
  final String source;
  final String message;

  const LogItem(
      {super.key,
      required this.level,
      required this.time,
      required this.source,
      required this.message});

  @override
  Widget build(BuildContext context) {
    Color badgeColor = Colors.grey;
    if (level == "ERROR") badgeColor = Colors.red;
    if (level == "WARN") badgeColor = Colors.amber;
    if (level == "INFO") badgeColor = Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: badgeColor)),
            child: Text(level,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeColor)),
          ),
          const SizedBox(width: 16),
          Text(time,
              style:
                  const TextStyle(fontFamily: 'monospace', color: Colors.grey)),
          const SizedBox(width: 16),
          Text(source, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Expanded(
              child: Text(message,
                  style: TextStyle(
                      color: level == "ERROR"
                          ? Colors.red[300]
                          : Colors.white70))),
        ],
      ),
    );
  }
}

// 스케줄러 카드
class SchedulerCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String interval;

  const SchedulerCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.interval});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF2f3136),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
              Switch(value: true, onChanged: (v) {}, activeColor: Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: interval,
            decoration: const InputDecoration(
              labelText: "주기/시간 설정",
              filled: true,
              fillColor: Color(0xFF202225),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40444b)),
              child: const Text("설정 저장"),
            ),
          )
        ],
      ),
    );
  }
}
