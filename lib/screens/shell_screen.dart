import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends StatefulWidget {
  final Widget child; // 현재 라우트에 해당하는 화면 위젯

  const ShellScreen({super.key, required this.child});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  // 현재 선택된 탭 인덱스를 URL 경로를 기반으로 계산
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/logs')) return 1;
    if (location.startsWith('/scheduler')) return 2;
    if (location.startsWith('/whitelist')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  // 탭 이동 처리
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/logs');
        break;
      case 2:
        context.go('/scheduler');
        break;
      case 3:
        context.go('/whitelist');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      // 모바일용 AppBar
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: const Color(0xFF2f3136),
              title: const Text("Bot Admin"),
              elevation: 0,
            )
          : null,
      // 모바일용 Drawer
      drawer: !isDesktop
          ? Drawer(
              child:
                  _buildSidebarContent(context, selectedIndex, isMobile: true),
            )
          : null,
      body: Row(
        children: [
          // 데스크톱용 사이드바
          if (isDesktop)
            SizedBox(
              width: 250,
              child:
                  _buildSidebarContent(context, selectedIndex, isMobile: false),
            ),
          // 메인 컨텐츠 영역 (여기에 각 스크린이 표시됨)
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _buildDesktopHeader(context, selectedIndex),
                Expanded(child: widget.child), // [중요] GoRouter가 주는 화면 표시
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 사이드바 위젯
  Widget _buildSidebarContent(BuildContext context, int selectedIndex,
      {required bool isMobile}) {
    return Container(
      color: const Color(0xFF202225),
      child: Column(
        children: [
          // 로고
          Container(
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF2f3136)))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smart_toy, color: Color(0xFF5865F2), size: 28),
                SizedBox(width: 12),
                Text("Bot Admin",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
          // 메뉴 리스트
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              children: [
                _navItem(context, 0, Icons.dashboard, "대시보드", selectedIndex,
                    isMobile),
                _navItem(context, 1, Icons.description, "시스템 로그", selectedIndex,
                    isMobile),
                _navItem(context, 2, Icons.schedule, "스케줄러", selectedIndex,
                    isMobile),
                _navItem(context, 3, Icons.people, "화이트리스트", selectedIndex,
                    isMobile),
                _navItem(context, 4, Icons.settings, "설정 & API", selectedIndex,
                    isMobile),
              ],
            ),
          ),
          // 프로필 영역
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF2f3136)))),
            child: Row(
              children: [
                const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white)),
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

  Widget _navItem(BuildContext context, int index, IconData icon, String label,
      int selectedIndex, bool isMobile) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
      title: Text(label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      tileColor: isSelected ? const Color(0xFF40444b) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        _onItemTapped(index, context);
        if (isMobile) Navigator.pop(context); // 모바일이면 Drawer 닫기
      },
    );
  }

  Widget _buildDesktopHeader(BuildContext context, int selectedIndex) {
    // 타이틀 매핑
    final titles = ["대시보드", "시스템 로그", "스케줄러", "화이트리스트", "설정 & API"];
    final currentTitle = titles[selectedIndex];

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: const Color(0xFF2f3136),
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
              Text(currentTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
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
}
