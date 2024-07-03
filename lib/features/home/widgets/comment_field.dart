import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecuaria_news/features/home/widgets/login_state.dart';
import 'package:provider/provider.dart';

class CommentField extends StatefulWidget {
  final String idNews;
  final String? userName;

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
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/comments.json';
      final file = File(path);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonResponse = json.decode(jsonString);
        setState(() {
          newsComments = jsonResponse['newsComments'];
        });
        print('Comentários carregados do arquivo: $newsComments');
      } else {
        final jsonString =
            await rootBundle.loadString('assets/json/comments.json');
        final jsonResponse = json.decode(jsonString);
        setState(() {
          newsComments = jsonResponse['newsComments'];
        });
        await saveCommentsToFile(newsComments);
        print('Comentários carregados do bundle: $newsComments');
      }
    } catch (e) {
      print('Erro ao carregar os comentários: $e');
    }
  }

  void _submitComment() async {
    final userName = Provider.of<LoginState>(context, listen: false)
        .currentUser
        ?.displayName;
    final userId =
        Provider.of<LoginState>(context, listen: false).currentUser?.uid;
    final commenterName = userName ?? 'Anonymous';

    if (_commentController.text.isNotEmpty) {
      final newComment = {
        "idUser": userId ?? '0',
        "commenter": commenterName,
        "date": DateTime.now().toString(),
        "content": _commentController.text,
        "photoUrl": ""
      };

      int newsItemIndex =
          newsComments.indexWhere((news) => news['idNews'] == widget.idNews);
      if (newsItemIndex != -1) {
        setState(() {
          newsComments[newsItemIndex]['comments'].add(newComment);
        });
        print('Comentário adicionado: $newComment');
        await saveCommentsToFile(newsComments);
      } else {
        print('IdNews não encontrado');
      }
      _commentController.clear();
    }
  }

  Future<void> saveCommentsToFile(List<dynamic> comments) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/comments.json';
      final file = File(path);
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      String jsonContent = jsonEncode({"newsComments": comments});
      print('Salvando comentários no arquivo: $jsonContent');
      await file.writeAsString(jsonContent);
      print('Comentários salvos com sucesso.');
    } catch (e) {
      print('Erro ao salvar os comentários: $e');
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
      print('Nenhum item de notícia correspondente encontrado: $e');
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
                border: InputBorder.none,
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('Faça login para comentar.',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        const SizedBox(height: 16.0),
        if (filteredComments.isNotEmpty)
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
