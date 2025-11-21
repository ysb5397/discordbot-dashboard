import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:discordbot_dashboard/screens/shell_screen.dart';
import 'package:discordbot_dashboard/screens/dashboard_screen.dart';
import 'package:discordbot_dashboard/screens/logs_screen.dart';
import 'package:discordbot_dashboard/screens/scheduler_screen.dart';
import 'package:discordbot_dashboard/screens/whitelist_screen.dart';
import 'package:discordbot_dashboard/screens/settings_screen.dart';
import '../../screens/login_screen.dart';

// GlobalKey를 사용하여 NavigatorState에 접근 (Context 없이 이동할 때 유용)
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login', // 앱 시작 시 첫 화면
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // 1. ShellRoute: 사이드바/헤더 등 공통 UI를 감싸는 라우트
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // ShellScreen은 공통 레이아웃(사이드바 등)을 담당하고, child에 실제 페이지 내용을 표시함
        return ShellScreen(child: child);
      },
      routes: [
        // 1-1. 대시보드 (기본)
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        // 1-2. 시스템 로그
        GoRoute(
          path: '/logs',
          name: 'logs',
          builder: (context, state) => const LogsScreen(),
        ),
        // 1-3. 스케줄러
        GoRoute(
          path: '/scheduler',
          name: 'scheduler',
          builder: (context, state) => const SchedulerScreen(),
        ),
        // 1-4. 화이트리스트
        GoRoute(
          path: '/whitelist',
          name: 'whitelist',
          builder: (context, state) => const WhitelistScreen(),
        ),
        // 1-5. 설정 & API
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
  // 에러 발생 시 보여줄 페이지
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('페이지를 찾을 수 없습니다: ${state.error}')),
  ),
);
