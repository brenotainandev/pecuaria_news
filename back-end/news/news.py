from flask import Flask, jsonify
import mysql.connector as mysql

servico = Flask("news")

SERVIDOR_BANCO = "database"
USUARIO_BANCO = "user"
SENHA_BANCO = "123456"
NOME_BANCO = "pecuaria_news_db"

def get_conexao_com_bd():
    conexao = mysql.connect(host=SERVIDOR_BANCO, user=USUARIO_BANCO, password=SENHA_BANCO, database=NOME_BANCO)
    return conexao

@servico.get("/info")
def get_info():
    return jsonify(
        descricao = "gerenciamento de notícias",
        versao = "1.0"
    )

@servico.get("/news/<int:ultimo_feed>/<int:tamanho_da_pagina>")
def get_news(ultimo_feed, tamanho_da_pagina):
    noticias = []

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        "SELECT news.idNews as news_id, DATE_FORMAT(news.date, '%Y-%m-%d') as date, " +
        "news.category, news.author, news.authorImageAssetPath, news.title, news.content, news.imageAssetPath " +
        "FROM news " +
        "WHERE news.idNews > %s ORDER BY news_id ASC, date DESC " +
        "LIMIT %s", (ultimo_feed, tamanho_da_pagina)
    )
    noticias = cursor.fetchall()

    conexao.close()

    return jsonify(noticias)

@servico.get("/news/<int:ultimo_feed>/<int:tamanho_da_pagina>/<string:titulo>")
def find_news(ultimo_feed, tamanho_da_pagina, titulo):
    noticias = []

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        "SELECT news.idNews as news_id, DATE_FORMAT(news.date, '%Y-%m-%d') as date, " +
        "news.category, news.author, news.authorImageAssetPath, news.title, news.content, news.imageAssetPath " +
        "FROM news " +
        "WHERE news.title LIKE %s AND news.idNews > %s ORDER BY news_id ASC, date DESC " +
        "LIMIT %s", ('%' + titulo + '%', ultimo_feed, tamanho_da_pagina)
    )
    noticias = cursor.fetchall()

    conexao.close()

    return jsonify(noticias)

@servico.get("/news/<int:feed>")
def find_news_by_id(feed):
    noticia = {}

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        "SELECT news.idNews as news_id, DATE_FORMAT(news.date, '%Y-%m-%d') as date, " +
        "news.category, news.author, news.authorImageAssetPath, news.title, news.content, news.imageAssetPath " +
        "FROM news " +
        "WHERE news.idNews = %s", (feed,)
    )
    noticia = cursor.fetchone()

    conexao.close()

    return jsonify(noticia)

if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)