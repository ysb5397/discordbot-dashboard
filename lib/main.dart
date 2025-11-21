import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discordbot_dashboard/_global/constants/theme.dart';
import 'package:discordbot_dashboard/_global/constants/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: BotAdminApp(),
    ),
  );
}

class BotAdminApp extends StatelessWidget {
  const BotAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Discord Bot Admin',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: router,
    );
  }
}
