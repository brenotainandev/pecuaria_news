from flask import Flask, jsonify
import mysql.connector as mysql

servico = Flask("comments")

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
        descricao = "gerenciamento de Comentarios do pecuaria news",
        versao = "1.0"
    )

@servico.get("/comments/<int:id_news>")
def get_all_comments(id_news):
    comments = []

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute("SELECT idComment, idUser, idNews, content, commenter, photoUrl, DATE_FORMAT(date, '%Y-%m-%d %H:%i') as data " +
                   "FROM comments " +
                   "WHERE idNews = %s ORDER BY idComment ASC, date DESC", (id_news,))
    comments = cursor.fetchall()
    conexao.close()

    return jsonify(comments)

@servico.get("/comments/<int:id_news>/<int:ultimo_comentario>/<int:tamanho_pagina>")
def get_comments(id_news, ultimo_comentario, tamanho_pagina):
    comments = []

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute("SELECT idComment, idUser, idNews, content, commenter, photoUrl, DATE_FORMAT(date, '%Y-%m-%d %H:%i') as data " +
                   "FROM comments " +
                   "WHERE idNews = %s AND idComment > %s ORDER BY idComment ASC, date DESC " +
                   "LIMIT %s", (id_news, ultimo_comentario, tamanho_pagina))
    comments = cursor.fetchall()
    conexao.close()

    return jsonify(comments)

@servico.post("/adicionar/<int:id_news>/<string:commenter>/<string:photo_url>/<string:content>")
def add_comentario(id_news, commenter, photo_url, content):
    resultado = jsonify(situacao = "ok", erro = "")

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor()
    try:
        cursor.execute(
            "INSERT INTO comments(idNews, commenter, photoUrl, content, date) VALUES(%s, %s, %s, %s, NOW())", 
            (id_news, commenter, photo_url, content))
        conexao.commit()
    except:
        conexao.rollback()
        resultado = jsonify(situacao = "erro", erro = "erro adicionando comentário")

    conexao.close()

    return resultado

@servico.delete("/remover/<int:comentario_id>")
def remover_comentario(comentario_id):
    resultado = jsonify(situacao = "ok", erro = "")

    conexao = get_conexao_com_bd()
    cursor = conexao.cursor()
    try:
        cursor.execute(
            "DELETE FROM comments WHERE idComment = %s", (comentario_id,))
        conexao.commit()
    except:
        conexao.rollback()
        resultado = jsonify(situacao = "erro", erro = "erro removendo o comentário")

    conexao.close()

    return resultado

if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)