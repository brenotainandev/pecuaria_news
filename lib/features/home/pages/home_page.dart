import 'package:flutter/material.dart';
import 'package:pecuaria_news/features/home/widgets/home_heading.dart';
import 'package:pecuaria_news/features/home/widgets/home_top_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeTopButtons(),
            HomeHeading(
                title: 'Novas Noticias',
                trailing: TextButton(
                    onPressed: () {}, child: const Text('Ver tudo'))),
            const Center(
              child: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
