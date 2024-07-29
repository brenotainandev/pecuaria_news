import 'package:flutter/material.dart';
import 'package:pecuaria_news/api/servicos.dart';
import 'package:pecuaria_news/features/home/widgets/home_slider_indicator_item.dart';
import 'package:pecuaria_news/features/home/widgets/home_slider_item.dart';

class HomeSlide extends StatefulWidget {
  const HomeSlide({super.key});

  @override
  State<HomeSlide> createState() => _HomeSlideState();
}

class _HomeSlideState extends State<HomeSlide> {
  late final PageController _pageController;
  late final ScrollController _scrollController;
  late final double _indicatorsVisibleWidth;

  late ServicoNews _servicoNNews;

  int _pageIndex = 0;

  final _displayIdicatorsCount = 5.0;
  final _indicatorWidth = 10.0;
  final _activedIndicatorWidth = 32.0;
  final _indicatorMargin = const EdgeInsets.symmetric(horizontal: 1);
  List<dynamic> newsItems = [];

  @override
  void initState() {
    super.initState();
    _servicoNNews = ServicoNews();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1000);
    _scrollController =
        ScrollController(initialScrollOffset: _calculateIndicatorOffset());
    _indicatorsVisibleWidth = _calculateIndicatorWidth();
    _loadNewsItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadNewsItems() async {
    try {
      final news = await _servicoNNews.getProdutos(
          0, 5); // Carregar as 5 primeiras notícias
      setState(() {
        newsItems = news; // Atualizar o estado com os itens de notícias
      });
    } catch (e) {
      print("Erro ao carregar notícias: $e");
    }
  }

  double _calculateIndicatorWidth() {
    final indicatorTotalWidth =
        _indicatorWidth + _indicatorMargin.left + _indicatorMargin.right;
    final activedIndicatorTotalWidth =
        _activedIndicatorWidth + _indicatorMargin.left + _indicatorMargin.right;
    return activedIndicatorTotalWidth +
        ((_displayIdicatorsCount - 1) * indicatorTotalWidth);
  }

  double _calculateIndicatorOffset() {
    final indicatorsCountBeforeCentral = (_displayIdicatorsCount - 1) / 2;
    final offset =
        (_indicatorWidth + _indicatorMargin.left + _indicatorMargin.right) *
            (_pageIndex + 999 - indicatorsCountBeforeCentral);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se newsItems está vazio
    if (newsItems.isEmpty) {
      // Retorna um CircularProgressIndicator enquanto os dados estão sendo carregados
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Se newsItems não estiver vazio, retorna o conteúdo atual
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: 235,
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _pageIndex = index % newsItems.length;
                });
                _scrollController.animateTo(
                  _calculateIndicatorOffset(),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                final i = index % newsItems.length;
                return HomeSliderItem(
                  isActived: _pageIndex == i,
                  imageAssetPath: newsItems[i]['imageAssetPath'] != null
                      ? caminhoArquivo(newsItems[i]['imageAssetPath']!)
                      : '',
                  idNews: newsItems[i]['idNews'] ?? '',
                  category: newsItems[i]['category'] ?? '',
                  title: newsItems[i]['title'] ?? '',
                  content: newsItems[i]['content'] ?? '',
                  author: newsItems[i]['author'] ?? '',
                  authorImageAssetPath: newsItems[i]['authorImageAssetPath'] !=
                          null
                      ? caminhoArquivo(newsItems[i]['authorImageAssetPath']!)
                      : '',
                  date: newsItems[i]['date'] != null
                      ? DateTime.parse(newsItems[i]['date']!)
                      : DateTime.now(),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            child: SizedBox(
              width: _indicatorsVisibleWidth,
              height: _indicatorWidth,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final i = index % newsItems.length;
                  return HomeSliderIndicatorItem(
                    isActived: index == _pageIndex + 999,
                    activedWidth: _activedIndicatorWidth,
                    width: _indicatorWidth,
                    margin: _indicatorMargin,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
