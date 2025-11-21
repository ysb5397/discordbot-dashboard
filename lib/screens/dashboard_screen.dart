import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:discordbot_dashboard/_global/api_service.dart'; // API 서비스 import

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 데이터 로드를 위한 Future
  late Future<Map<String, dynamic>> _statsFuture;
  late Future<List<dynamic>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // 데이터 새로고침
  void _refreshData() {
    setState(() {
      _statsFuture = apiService.fetchStats();
      _logsFuture = apiService.fetchLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 상단 앱바 대신 본문 상단에 타이틀과 새로고침 버튼 배치 (ShellScreen 내부에 있으므로)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 헤더 (타이틀 + 새로고침 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("대시보드 개요",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                IconButton(
                  onPressed: _refreshData,
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  tooltip: "새로고침",
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 1. 통계 카드 섹션
            _buildStatsSection(),

            const SizedBox(height: 32),

            // 2. 최근 로그 섹션
            const Text("최근 활동 로그",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            _buildLogsSection(),
          ],
        ),
      ),
    );
  }

  // --- 통계 섹션 ---
  Widget _buildStatsSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else if (!snapshot.hasData) {
          return const Center(child: Text("데이터 없음"));
        }

        final stats = snapshot.data!;
        final uptimeSec = (stats['uptime'] as num).toInt();
        final uptimeStr =
            "${(uptimeSec / 3600).floor()}h ${(uptimeSec % 3600 / 60).floor()}m";

        // 화면 크기에 따른 그리드 컬럼 수 조정 (반응형)
        int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 2;
        // 모바일 화면일 경우 1열로 표시
        if (MediaQuery.of(context).size.width < 600) crossAxisCount = 1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: [
            StatCard(
              title: "Total Interactions",
              value: "${stats['totalInteractions']}",
              icon: Icons.chat_bubble,
              color: const Color(0xFF5865F2),
            ),
            StatCard(
              title: "Pending Errors",
              value: "${stats['errorCount']}",
              icon: Icons.warning_amber,
              color: Colors.amber,
              isAlert: (stats['errorCount'] > 0),
            ),
            StatCard(
              title: "Bot Uptime",
              value: uptimeStr,
              icon: Icons.timer,
              color: Colors.green,
            ),
            const StatCard(
              title: "API Status",
              value: "Online",
              icon: Icons.wifi,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }

  // --- 로그 섹션 ---
  Widget _buildLogsSection() {
    return FutureBuilder<List<dynamic>>(
      future: _logsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("로그 로드 실패: ${snapshot.error}",
              style: const TextStyle(color: Colors.red));
        }

        final logs = snapshot.data!;
        if (logs.isEmpty) return const Text("로그 내역이 없습니다.");

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length > 5 ? 5 : logs.length, // 미리보기는 최대 5개만
          separatorBuilder: (_, __) => const Divider(color: Colors.grey),
          itemBuilder: (context, index) {
            final log = logs[index];
            final time = DateTime.parse(log['timestamp']).toLocal();
            return LogItem(
              level: log['type'] ?? 'INFO',
              time: DateFormat('MM-dd HH:mm:ss').format(time),
              source: log['userId'] ?? 'System',
              message: log['content'].toString(),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 16),
          Expanded(
              child: Text("데이터 로드 실패: $error",
                  style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

// --- 위젯 컴포넌트 (StatCard, LogItem) ---
// 나중에 lib/_global/widgets 같은 곳으로 빼는 것도 좋아!

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isAlert;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
              Icon(icon, color: color, size: 20)
            ],
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isAlert ? Colors.amber : Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final String level;
  final String time;
  final String source;
  final String message;

  const LogItem({
    super.key,
    required this.level,
    required this.time,
    required this.source,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor = Colors.blue;
    if (level == "ERROR") badgeColor = Colors.red;
    if (level == "WARN") badgeColor = Colors.amber;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60, // 고정 너비로 정렬 맞춤
            padding: const EdgeInsets.symmetric(vertical: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: badgeColor),
            ),
            child: Text(level,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeColor)),
          ),
          const SizedBox(width: 16),
          Text(time,
              style: const TextStyle(
                  fontFamily: 'monospace', color: Colors.grey, fontSize: 12)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                Text(source,
                    style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
