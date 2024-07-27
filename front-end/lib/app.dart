import 'package:flutter/material.dart';
import 'package:pecuaria_news/core/main_page.dart';
import 'package:pecuaria_news/theme/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pecuaria - News App',
      theme: ThemeData(
        primarySwatch: AppColors.azureRadianceSwtch,
        primaryColor: AppColors.azureRadiance,
        scaffoldBackgroundColor: AppColors.white,
      ),
      home: const MainPage(),
    );
  }
}
