import 'package:flutter/material.dart';
import 'package:pecuaria_news/dummy.dart';
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
  final List<Map<String, String>> _comments = [];

  void _submitComment() {
    // Acessar o nome do usuário
    final userName =
        Provider.of<LoginState>(context, listen: false).currentUser?.userName;

// Acessar o ID do usuário
    final userId =
        Provider.of<LoginState>(context, listen: false).currentUser?.userId;
    final commenterName =
        userName ?? 'Anonymous'; // Usa o nome do usuário se fornecido
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add({
          'commenter': commenterName,
          'date': DateTime.now().toString(),
          'content': _commentController.text,
        });
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acessar o estado de login
    final loginState = Provider.of<LoginState>(context);
    final isLoggedIn = loginState.currentUser !=
        null; // ou use loginState.userId para verificar se está logado

    List<Map<String, String>> filteredComments = [];

    try {
      final newsItem =
          newsComments.firstWhere((news) => news['idNews'] == widget.idNews);
      if (newsItem['comments'] != null) {
        filteredComments =
            (newsItem['comments'] as List<dynamic>).cast<Map<String, String>>();
      }
    } catch (e) {
      // Tratar o caso em que nenhum item de notícia correspondente é encontrado
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLoggedIn) // Mostrar o campo de comentário somente se o usuário estiver logado
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Adicione um comentário...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _submitComment,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('Faça login para comentar.',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        const SizedBox(height: 16.0),
        if (filteredComments.isNotEmpty || _comments.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comentários:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8.0),
              ...filteredComments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${comment['commenter']} (${comment['date']}): ${comment['content']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              ..._comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${comment['commenter']} (${comment['date']}): ${comment['content']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ],
          ),
      ],
    );
  }
}
