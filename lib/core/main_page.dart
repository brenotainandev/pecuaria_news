import 'package:flutter/material.dart';
import 'package:pecuaria_news/core/bottom_nav_bar.dart';
import 'package:pecuaria_news/features/bookmarks/pages/bookmarks_page.dart';
import 'package:pecuaria_news/features/browse/pages/browse_page.dart';
import 'package:pecuaria_news/features/home/pages/home_page.dart';
import 'package:pecuaria_news/features/profile/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: const [
          HomePage(),
          BrowsePage(),
          BookmarksPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
