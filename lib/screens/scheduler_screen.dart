import 'package:flutter/material.dart';

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  bool _earthquakeEnabled = true;
  bool _briefingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "자동화 스케줄 관리",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(builder: (context, constraints) {
              // Responsive Grid
              int crossAxisCount = constraints.maxWidth > 900 ? 2 : 1;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.5, // Adjust as needed
                children: [
                  _buildEarthquakeCard(),
                  _buildBriefingCard(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEarthquakeCard() {
    return Card(
      color: const Color(0xFF2f3136),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.show_chart,
                        color: Colors.red,
                        size: 24), // Activity icon replacement
                    SizedBox(width: 8),
                    Text("지진 감지 (Earthquake)",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                Switch(
                  value: _earthquakeEnabled,
                  onChanged: (v) => setState(() => _earthquakeEnabled = v),
                  activeThumbColor: Colors.green,
                  activeTrackColor: Colors.green.withOpacity(0.5),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInputLabel("감지 주기 (초)"),
            const SizedBox(height: 8),
            _buildTextInput("60"),
            const SizedBox(height: 16),
            _buildInputLabel("알림 채널 ID"),
            const SizedBox(height: 8),
            _buildTextInput("123456789012345678", enabled: false),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF374151), // gray-700
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("설정 저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBriefingCard() {
    return Card(
      color: const Color(0xFF2f3136),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.newspaper, color: Colors.blue, size: 24),
                    SizedBox(width: 8),
                    Text("일일 브리핑 (Briefing)",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
                Switch(
                  value: _briefingEnabled,
                  onChanged: (v) => setState(() => _briefingEnabled = v),
                  activeThumbColor: Colors.green,
                  activeTrackColor: Colors.green.withOpacity(0.5),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInputLabel("브리핑 시간 (KST)"),
            const SizedBox(height: 8),
            _buildTextInput(
                "08:30"), // Time picker could be better but text input for now
            const SizedBox(height: 16),
            _buildInputLabel("브리핑 주제"),
            const SizedBox(height: 8),
            _buildTextInput("오늘의 주요 IT 및 세계 뉴스 요약"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF374151), // gray-700
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("설정 저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(label,
        style: const TextStyle(
            color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500));
  }

  Widget _buildTextInput(String initialValue, {bool enabled = true}) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      enabled: enabled,
      style: TextStyle(color: enabled ? Colors.white : Colors.grey),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF202225), // gray-900
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF374151)), // gray-700
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF5865F2)), // Indigo-500
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
