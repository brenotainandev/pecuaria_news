import 'package:flutter/material.dart';
import 'package:pecuaria_news/dummy.dart';

class CommentField extends StatefulWidget {
  final String idNews;

  const CommentField({super.key, required this.idNews});

  @override
  CommentFieldState createState() => CommentFieldState();
}

class CommentFieldState extends State<CommentField> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [];

  void _submitComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add({
          'commenter':
              'Anonymous', // You can replace this with the actual commenter if available
          'date': DateTime.now().toString(),
          'content': _commentController.text,
        });
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredComments = [];

    try {
      final newsItem =
          newsComments.firstWhere((news) => news['idNews'] == widget.idNews);
      if (newsItem['comments'] != null) {
        filteredComments =
            (newsItem['comments'] as List<dynamic>).cast<Map<String, String>>();
      }
    } catch (e) {
      // Handle the case where no matching news item is found
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Adicione um comentário...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _submitComment,
            ),
          ),
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
