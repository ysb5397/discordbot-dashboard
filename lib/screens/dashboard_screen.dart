import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:discordbot_dashboard/_global/constants/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _statsFuture = apiService.fetchStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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

            // 1. Stats Cards
            _buildStatsSection(),

            const SizedBox(height: 24),

            // 2. Charts & Server Status
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 1000) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildChartSection()),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _buildServerStatusSection()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildChartSection(),
                    const SizedBox(height: 24),
                    _buildServerStatusSection(),
                  ],
                );
              }
            }),

            const SizedBox(height: 32),

            // 3. Logs (Optional, kept for compatibility if needed, or removed if moved to separate screen)
            // Since we have a separate Logs screen, we might not need this here, but sample.html has it in a tab.
            // In this Flutter app, we separated Logs to a different route.
            // So we will skip the logs section here to match the "Dashboard Tab" of sample.html which has charts.
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        // Mock data if waiting or error for UI preview
        final stats = snapshot.hasData
            ? snapshot.data!
            : {
                'totalInteractions': 1284,
                'errorCount': 2,
                'uptime': 393120, // 4d 13h roughly
              };

        final uptimeSec = (stats['uptime'] as num).toInt();
        final days = (uptimeSec / 86400).floor();
        final hours = ((uptimeSec % 86400) / 3600).floor();
        final uptimeStr = "${days}d ${hours}h";

        // Responsive Grid
        int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 4 : 2;
        if (MediaQuery.of(context).size.width < 600) crossAxisCount = 1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.6,
          children: [
            StatCard(
              title: "Total Interactions",
              value: "${stats['totalInteractions']}",
              icon: Icons.chat_bubble_outline,
              color: const Color(0xFF6366F1), // Indigo-500
              subText: "+12.5% 이번 주",
              subTextColor: const Color(0xFF4ADE80), // green-400
              subIcon: Icons.arrow_outward,
            ),
            const StatCard(
              title: "Gemini Token Usage",
              value: "84,392",
              icon: Icons.psychology, // Brain-like
              color: Color(0xFFEC4899), // Pink-500
              subText: "Limit: 1,000,000 (8.4%)",
              subTextColor: Colors.grey,
            ),
            StatCard(
              title: "Pending Errors",
              value: "${stats['errorCount']}",
              icon: Icons.warning_amber,
              color: const Color(0xFFEAB308), // Yellow-500
              valueColor: const Color(0xFFFACC15), // Yellow-400
              subText: "Go to Maintenance →",
              subTextColor: Colors.grey,
              onTap: () => {}, // Navigate to logs
            ),
            StatCard(
              title: "Bot Uptime",
              value: uptimeStr,
              icon: Icons.timer,
              color: const Color(0xFF22C55E), // Green-500
              subText: "Last restart: Monday",
              subTextColor: Colors.grey,
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2f3136),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("📊 주간 AI 호출량 (Gemini vs Flowise)",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFF374151),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style =
                            TextStyle(color: Color(0xFF9CA3AF), fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Mon', style: style);
                            break;
                          case 1:
                            text = const Text('Tue', style: style);
                            break;
                          case 2:
                            text = const Text('Wed', style: style);
                            break;
                          case 3:
                            text = const Text('Thu', style: style);
                            break;
                          case 4:
                            text = const Text('Fri', style: style);
                            break;
                          case 5:
                            text = const Text('Sat', style: style);
                            break;
                          case 6:
                            text = const Text('Sun', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                        }
                        return SideTitleWidget(
                            axisSide: meta.axisSide, child: text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(),
                            style: const TextStyle(
                                color: Color(0xFF9CA3AF), fontSize: 12));
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 140,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 65),
                      FlSpot(1, 59),
                      FlSpot(2, 80),
                      FlSpot(3, 81),
                      FlSpot(4, 56),
                      FlSpot(5, 95),
                      FlSpot(6, 120),
                    ],
                    isCurved: true,
                    color: const Color(0xFF6366F1),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.5),
                          const Color(0xFF6366F1).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerStatusSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2f3136),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("⚡ 실시간 서버 상태",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 24),
          _buildProgressBar("CPU Usage", 0.12, Colors.green),
          const SizedBox(height: 16),
          _buildProgressBar("Memory (RAM)", 0.64, Colors.amber),
          const SizedBox(height: 16),
          _buildProgressBar("API Latency", 0.20, Colors.blue,
              valueText: "45ms"),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF4B5563)),
          const SizedBox(height: 24),
          const Text("Active Voice Sessions",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 16),
          _buildVoiceSessionItem(
              "일반 (Music)", 1, Icons.music_note, Colors.redAccent),
          const SizedBox(height: 8),
          _buildVoiceSessionItem(
              "Gemini Live", 0, Icons.mic, Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double percent, Color color,
      {String? valueText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text(valueText ?? "${(percent * 100).toInt()}%",
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: const Color(0xFF374151),
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildVoiceSessionItem(
      String name, int users, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text("$name - $users users",
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color? valueColor;
  final String? subText;
  final Color? subTextColor;
  final IconData? subIcon;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.valueColor,
    this.subText,
    this.subTextColor,
    this.subIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2f3136),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? Colors.white),
                ),
                if (subText != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (subIcon != null)
                        Icon(subIcon, color: subTextColor, size: 14),
                      if (subIcon != null) const SizedBox(width: 4),
                      Text(subText!,
                          style: TextStyle(color: subTextColor, fontSize: 12)),
                    ],
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
