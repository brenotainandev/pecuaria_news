import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecuaria_news/features/home/widgets/login_state.dart';
import 'package:provider/provider.dart';

class CommentField extends StatefulWidget {
  final String idNews;
  final String? userName; // Parâmetro opcional para o nome do usuário

  const CommentField({super.key, required this.idNews, this.userName});

  @override
  CommentFieldState createState() => CommentFieldState();
}

class CommentFieldState extends State<CommentField> {
  final TextEditingController _commentController = TextEditingController();
  List<dynamic> newsComments = [];

  @override
  void initState() {
    super.initState();
    _loadCommentsItems();
  }

  Future<void> _loadCommentsItems() async {
    final jsonString = await rootBundle.loadString('assets/json/comments.json');
    final jsonResponse = json.decode(jsonString);
    setState(() {
      newsComments = jsonResponse['newsComments'];
    });
  }

  void _submitComment() {
    final userName = Provider.of<LoginState>(context, listen: false)
        .currentUser
        ?.displayName;
    final userId =
        Provider.of<LoginState>(context, listen: false).currentUser?.uid;
    final commenterName = userName ?? 'Anonymous';

    if (_commentController.text.isNotEmpty) {
      final newComment = {
        "idUser": userId ??
            '0', // Use um valor padrão ou gere um ID conforme necessário
        "commenter": commenterName,
        "date": DateTime.now().toString(),
        "content": _commentController.text,
        "photoUrl": ""
      };

      setState(() {
        final newsItemIndex =
            newsComments.indexWhere((news) => news['idNews'] == widget.idNews);
        if (newsItemIndex != -1) {
          newsComments[newsItemIndex]['comments'].add(newComment);
        } else {
          // Tratar caso onde o idNews não é encontrado, se necessário
        }
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context);
    final isLoggedIn = loginState.currentUser != null;

    List<dynamic> filteredComments = [];

    try {
      final newsItem =
          newsComments.firstWhere((news) => news['idNews'] == widget.idNews);
      if (newsItem['comments'] != null) {
        filteredComments = newsItem['comments'];
      }
    } catch (e) {
      // Tratar o caso em que nenhum item de notícia correspondente é encontrado
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoggedIn)
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Adicione um comentário...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                ),
                border: InputBorder
                    .none, // Adicione esta linha para remover a borda
                alignLabelWithHint:
                    true, // Isso ajuda a centralizar o hint quando o campo está vazio
                contentPadding: const EdgeInsets.fromLTRB(
                    12, 12, 12, 12), // Ajuste conforme necessário
              ),
              textAlignVertical:
                  TextAlignVertical.center, // Centraliza o texto verticalmente
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('Faça login para comentar.',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        const SizedBox(height: 16.0),
        if (filteredComments.isNotEmpty) // Removida a referência a _comments
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comentários:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              ...filteredComments.map((comment) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, size: 40.0),
                    title: Text('${comment['commenter']} (${comment['date']})'),
                    subtitle: Text('${comment['content']}'),
                  ),
                );
              }).toList(),
            ],
          ),
      ],
    );
  }
}
