import 'package:flutter/material.dart';
import 'package:pecuaria_news/features/home/widgets/home_heading.dart';
import 'package:pecuaria_news/features/home/widgets/home_slider.dart';
import 'package:pecuaria_news/features/home/widgets/home_top_buttons.dart';
import 'package:pecuaria_news/features/home/widgets/news_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const HomeTopButtons(),
            HomeHeading(
              title: 'Últimas notícias',
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Ver mais'),
              ),
            ),
            const HomeSlide(),
            HomeHeading(
              title: 'Recomendações',
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Ver mais'),
              ),
            ),
            const NewsList(),
          ],
        ),
      ),
    );
  }
}
