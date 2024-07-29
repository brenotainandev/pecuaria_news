// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'dart:convert';

import "package:http/http.dart" as http;

final URL_SERVICOS = Uri.parse("http://192.168.0.11");

final URL_NEWS = "${URL_SERVICOS.toString()}:5001/news";

final URL_ARQUIVOS = "${URL_SERVICOS.toString()}:5005";

class ServicoNews {
  static const String URL_NEWS = "http://192.168.0.11:5001/news";

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
  static const String URL_COMMENTS = "http://192.168.0.11:5001/comments";

  Future<List<dynamic>> getAllComments(int idNews) async {
    final resposta = await http.get(Uri.parse("$URL_COMMENTS/$idNews"));
    final comments = jsonDecode(resposta.body);
    return comments;
  }

  Future<List<dynamic>> getComments(
      int idNews, int ultimoComentario, int tamanhoPagina) async {
    final resposta = await http.get(
        Uri.parse("$URL_COMMENTS/$idNews/$ultimoComentario/$tamanhoPagina"));
    final comments = jsonDecode(resposta.body);
    return comments;
  }

  Future<Map<String, dynamic>> addComentario(
      int idNews, String commenter, String photoUrl, String content) async {
    final resposta = await http.post(
      Uri.parse(
          "$URL_COMMENTS/adicionar/$idNews/$commenter/$photoUrl/$content"),
    );
    final result = jsonDecode(resposta.body);
    return result;
  }

  Future<Map<String, dynamic>> removerComentario(int comentarioId) async {
    final resposta =
        await http.delete(Uri.parse("$URL_COMMENTS/remover/$comentarioId"));
    final result = jsonDecode(resposta.body);
    return result;
  }
}

String caminhoArquivo(String arquivo) {
  return "${URL_ARQUIVOS.toString()}/$arquivo";
}
