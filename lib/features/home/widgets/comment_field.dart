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
  final String? idUser;

  const CommentField(
      {super.key, required this.idNews, this.userName, this.idUser});

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

    print('userId: $userId');
    if (_commentController.text.isNotEmpty) {
      final newCommentId = DateTime.now().millisecondsSinceEpoch.toString();

      final newComment = {
        "idComment": newCommentId,
        "idUser": userId ?? '0',
        "commenter": commenterName,
        "date": DateTime.now().toString(),
        "content": _commentController.text,
        "photoUrl": ""
      };

      int newsItemIndex =
          newsComments.indexWhere((news) => news['idNews'] == widget.idNews);
      if (newsItemIndex != -1) {
        if (newsComments[newsItemIndex]['comments'] == null) {
          newsComments[newsItemIndex]['comments'] = [];
        }
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

  Future<void> _editComment(String commentId, String newContent) async {
    final userId =
        Provider.of<LoginState>(context, listen: false).currentUser?.uid;
    print('Tentando editar comentário. UserID: $userId, CommentID: $commentId');

    if (userId == null) {
      print('Usuário não autenticado.');
      return;
    }

    int newsItemIndex =
        newsComments.indexWhere((news) => news['idNews'] == widget.idNews);
    print('NewsItemIndex: $newsItemIndex');

    if (newsItemIndex != -1) {
      List<dynamic> comments = newsComments[newsItemIndex]['comments'];
      int commentIndex = comments.indexWhere((comment) =>
          comment['idComment'] == commentId && comment['idUser'] == userId);
      print('CommentIndex: $commentIndex');

      if (commentIndex != -1) {
        setState(() {
          newsComments[newsItemIndex]['comments'][commentIndex] = {
            ...newsComments[newsItemIndex]['comments'][commentIndex],
            'content': newContent,
            'date': DateTime.now().toString()
          };
        });
        print(
            'Comentário editado: ${newsComments[newsItemIndex]['comments'][commentIndex]}');
        await saveCommentsToFile(newsComments);
      } else {
        print(
            'Comentário não encontrado ou usuário não tem permissão para editar este comentário.');
      }
    } else {
      print('IdNews não encontrado');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    final userId =
        Provider.of<LoginState>(context, listen: false).currentUser?.uid;
    if (userId == null) {
      print('Usuário não autenticado.');
      return;
    }

    int newsItemIndex =
        newsComments.indexWhere((news) => news['idNews'] == widget.idNews);
    if (newsItemIndex != -1) {
      List<dynamic> comments = newsComments[newsItemIndex]['comments'];
      int commentIndex = comments.indexWhere((comment) =>
          comment['idComment'] == commentId && comment['idUser'] == userId);
      if (commentIndex != -1) {
        setState(() {
          newsComments[newsItemIndex]['comments'].removeAt(commentIndex);
        });
        print('Comentário deletado.');
        await saveCommentsToFile(newsComments);
      } else {
        print(
            'Comentário não encontrado ou usuário não tem permissão para deletar este comentário.');
      }
    } else {
      print('IdNews não encontrado');
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
                final DateTime commentDate = DateTime.parse(comment['date']);
                final String formattedDate =
                    "${commentDate.day}/${commentDate.month}/${commentDate.year}";
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, size: 40.0),
                    title: Text('${comment['commenter']} ($formattedDate)'),
                    subtitle: Text('${comment['content']}'),
                    trailing: Provider.of<LoginState>(context)
                                .currentUser
                                ?.uid ==
                            comment['idUser']
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final String text = comment['content'] ?? '';
                                  final String commentId =
                                      comment['idComment'] ?? '';
                                  final TextEditingController editController =
                                      TextEditingController(text: text);

                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Editar Comentário'),
                                        content: TextField(
                                          controller: editController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Digite seu comentário aqui"),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Salvar'),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await _editComment(commentId,
                                                  editController.text);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  final bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text('Confirmar exclusão'),
                                      content: Text(
                                          'Você realmente deseja excluir este comentário?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: Text('Excluir'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirmDelete) {
                                    await _deleteComment(comment['idComment']);
                                  }
                                },
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              }).toList(),
            ],
          ),
      ],
    );
  }
}
