import 'package:flutter/material.dart';
import 'package:pop_search/app/app_router.dart';
import 'package:pop_search/app/theme/app_theme.dart';

class PopSearchApp extends StatelessWidget {
  const PopSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopSearch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: AppRouter.home,
    );
  }
}
