// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'dart:convert';

import "package:http/http.dart" as http;

final URL_SERVICOS = Uri.parse("http://172.17.0.1");

final URL_NEWS = "${URL_SERVICOS.toString()}:5001/news";

final URL_ARQUIVOS = "${URL_SERVICOS.toString()}:5005";

class ServicoNews {
  static const String URL_NEWS = "http://172.17.0.1:5001/news";

  Future<List<dynamic>> getNews(int ultimoFeed, int tamanhoPagina) async {
    final resposta =
        await http.get(Uri.parse("$URL_NEWS/$ultimoFeed/$tamanhoPagina"));
    final feeds = jsonDecode(resposta.body);
    return feeds;
  }

  Future<List<dynamic>> findNews(
      int ultimoFeed, int tamanhoPagina, String titulo) async {
    final resposta = await http
        .get(Uri.parse("$URL_NEWS/$ultimoFeed/$tamanhoPagina/$titulo"));
    final feeds = jsonDecode(resposta.body);
    return feeds;
  }

  Future<Map<String, dynamic>> findNewsById(int feed) async {
    final resposta = await http.get(Uri.parse("$URL_NEWS/$feed"));
    final feedData = jsonDecode(resposta.body);
    return feedData;
  }
}

class ServicoComments {
  static const String URL_COMMENTS = "http://172.17.0.1:5002/comments";

  Future<List<dynamic>> getAllComments(int idNews) async {
    final resposta = await http.get(Uri.parse("$URL_COMMENTS/$idNews"));
    final comments = jsonDecode(resposta.body);
    return comments;
  }

  Future<Map<String, dynamic>> addComentario(int idNews, String displayName,
      String email, String photoUrl, String content, String uid) async {
    final resposta = await http.post(
      Uri.parse("$URL_COMMENTS/adicionar"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_news': idNews,
        'display_name': displayName,
        'email': email,
        'photo_url': photoUrl,
        'content': content,
        'uid': uid,
      }),
    );
    final result = jsonDecode(resposta.body);
    return result;
  }

  Future<Map<String, dynamic>> editarComentario(
      String comentarioId, String novoConteudo) async {
    final resposta = await http.put(
      Uri.parse("$URL_COMMENTS/editar/$comentarioId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'content': novoConteudo,
      }),
    );
    final result = jsonDecode(resposta.body);
    return result;
  }

  Future<Map<String, dynamic>> removerComentario(String comentarioId) async {
    final resposta =
        await http.delete(Uri.parse("$URL_COMMENTS/remover/$comentarioId"));
    final result = jsonDecode(resposta.body);
    return result;
  }
}

String caminhoArquivo(String arquivo) {
  return "${URL_ARQUIVOS.toString()}/$arquivo";
}
