import 'package:flutter/material.dart';
import 'package:pecuaria_news/api/servicos.dart';
import 'package:pecuaria_news/features/home/widgets/login_state.dart';
import 'package:pecuaria_news/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:pecuaria_news/core/utils/app_date_formattedrs.dart';

class CommentField extends StatefulWidget {
  final int idNews;
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
  late ServicoComments _servicoComments;

  @override
  void initState() {
    super.initState();
    _servicoComments = ServicoComments();
    _loadCommentsItems();
  }

  Future<void> _loadCommentsItems() async {
    print("this.idNews:  ${widget.idNews}");
    try {
      final comments = await _servicoComments.getAllComments(widget.idNews);
      setState(() {
        newsComments = comments;
      });
      print('Comentários carregados do endpoint: $newsComments');
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
      try {
        final newComment = await _servicoComments.addComentario(
          widget.idNews,
          commenterName,
          "", // photoUrl
          _commentController.text,
        );

        setState(() {
          newsComments.add(newComment);
        });
        print('Comentário adicionado: $newComment');
      } catch (e) {
        print('Erro ao adicionar comentário: $e');
      }
      _commentController.clear();
    }
  }

  Future<void> _editComment(String commentId, String newContent) async {}

  Future<void> _deleteComment(String commentId) async {
    final userId =
        Provider.of<LoginState>(context, listen: false).currentUser?.uid;
    if (userId == null) {
      print('Usuário não autenticado.');
      return;
    }

    try {
      await _servicoComments.removerComentario(int.parse(commentId));
      setState(() {
        newsComments
            .removeWhere((comment) => comment['idComment'] == commentId);
      });
      print('Comentário deletado.');
    } catch (e) {
      print('Erro ao deletar comentário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = Provider.of<LoginState>(context);
    final isLoggedIn = loginState.currentUser != null;

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
        if (newsComments.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comentários:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              ...newsComments.map((comment) {
                final DateTime commentDate = DateTime.parse(comment['data']);
                final String formattedDate = AppDateFormatters.mdY(commentDate);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, size: 40.0),
                    title: Text(
                      '${comment['commenter']} · $formattedDate',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.osloGrey,
                          ),
                    ),
                    subtitle: Text(
                      '${comment['content']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Provider.of<LoginState>(context)
                                .currentUser
                                ?.uid ==
                            comment['idUser']
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
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
                                        title: const Text('Editar Comentário'),
                                        content: TextField(
                                          controller: editController,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  "Digite seu comentário aqui"),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Salvar'),
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
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text(
                                          'Você realmente deseja excluir este comentário?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text('Excluir'),
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
