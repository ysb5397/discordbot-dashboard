import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  // Mock Data
  final List<Map<String, dynamic>> _logs = [
    {
      'level': 'ERROR',
      'msg': 'Gemini API Timeout (5000ms)',
      'source': 'ai_helper.js',
      'time': DateTime.now().subtract(const Duration(minutes: 2))
    },
    {
      'level': 'INFO',
      'msg': 'User "ysb5397" joined voice channel "Music"',
      'source': 'watch_voice.js',
      'time': DateTime.now().subtract(const Duration(minutes: 5))
    },
    {
      'level': 'WARN',
      'msg': 'Malicious URL detected and removed',
      'source': 'watch_chat.js',
      'time': DateTime.now().subtract(const Duration(minutes: 10))
    },
    {
      'level': 'INFO',
      'msg': 'Daily Briefing Generated Successfully',
      'source': 'scheduler.js',
      'time': DateTime.now().subtract(const Duration(hours: 4))
    },
    {
      'level': 'INFO',
      'msg': 'Bot Started (v1.0.0)',
      'source': 'index.js',
      'time': DateTime.now().subtract(const Duration(hours: 4, minutes: 1))
    },
  ];

  void _addMockLog() {
    setState(() {
      _logs.insert(0, {
        'level': 'INFO',
        'msg': 'Manual Refresh Triggered',
        'source': 'admin_dashboard',
        'time': DateTime.now(),
      });
      if (_logs.length > 10) _logs.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "시스템 및 에러 로그",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: _addMockLog,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("새로고침"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2), // Indigo-600
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table Card
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      color: const Color(0xFF1F2937), // gray-800
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: const Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("LEVEL",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("TIMESTAMP",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text("SOURCE",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 4,
                              child: Text("MESSAGE",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 1,
                              child: Text("ACTION",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    // Table Body
                    Expanded(
                      child: ListView.separated(
                        itemCount: _logs.length,
                        separatorBuilder: (context, index) => const Divider(
                            height: 1, color: Color(0xFF374151)), // gray-700
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          return _buildLogRow(log);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogRow(Map<String, dynamic> log) {
    Color badgeColor = Colors.blue;
    Color badgeBg = Colors.blue.withOpacity(0.1);
    Color textColor = Colors.grey;

    if (log['level'] == 'ERROR') {
      badgeColor = const Color(0xFFF87171); // red-400
      badgeBg = const Color(0xFF7F1D1D).withOpacity(0.5); // red-900/50
      textColor = const Color(0xFFF87171);
    } else if (log['level'] == 'WARN') {
      badgeColor = const Color(0xFFFBBF24); // yellow-400
      badgeBg = const Color(0xFF78350F).withOpacity(0.5); // yellow-900/50
      textColor = const Color(0xFFFBBF24);
    } else if (log['level'] == 'INFO') {
      badgeColor = const Color(0xFF60A5FA); // blue-400
      badgeBg = const Color(0xFF1E3A8A).withOpacity(0.5); // blue-900/50
      textColor = const Color(0xFF60A5FA);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: const Color(0xFF2f3136), // card color
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: badgeColor.withOpacity(0.3)),
                ),
                child: Text(
                  log['level'],
                  style: TextStyle(
                      color: badgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('HH:mm:ss').format(log['time']),
              style:
                  const TextStyle(fontFamily: 'monospace', color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              log['source'],
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              log['msg'],
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.grey, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
