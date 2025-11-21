import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "설정 & API",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Danger Zone
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2f3136),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color:
                        const Color(0xFFEF4444).withOpacity(0.3)), // red-500/30
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning, color: Color(0xFFF87171), size: 20),
                      SizedBox(width: 8),
                      Text("⚠️ 긴급 제어 (Danger Zone)",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF87171))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("서버에 문제가 생겼을 때만 사용하세요.",
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.power_settings_new, size: 18),
                        label: const Text("봇 강제 종료"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626), // red-600
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.storage, size: 18),
                        label: const Text("DB 연결 재설정 (/reload_db)"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFD97706), // yellow-600
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // API Key
            Card(
              color: const Color(0xFF2f3136),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("외부 앱 연동 API Key",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF202225), // gray-900
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF374151)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "flutterAI-v1732160000-a1b2c3d4",
                            style: TextStyle(
                                color: Color(0xFF4ADE80),
                                fontFamily: 'monospace',
                                fontSize: 14),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.grey),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(
                                  text: "flutterAI-v1732160000-a1b2c3d4"));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Copied to clipboard!")));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("마지막 갱신: 2025-11-20 14:00 (관리자 승인 필요)",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
