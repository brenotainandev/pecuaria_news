from flask import Flask, request, jsonify
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
    cursor.execute(
        "SELECT c.idComment, c.idUser, c.idNews, c.content, c.commenter, u.uid, DATE_FORMAT(c.date, '%Y-%m-%d %H:%i') as data " +
        "FROM comments c " +
        "JOIN users u ON c.idUser = u.idUser " +
        "WHERE c.idNews = %s ORDER BY c.idComment ASC, c.date DESC", (id_news,)
    )
    comments = cursor.fetchall()
    conexao.close()

    return jsonify(comments)

@servico.post("/comments/adicionar")
def add_comentario():
    resultado = jsonify(situacao="ok", erro="", comentario={})

    dados = request.get_json()
    id_news = dados.get("id_news")
    displayName = dados.get("display_name")
    email = dados.get("email")
    photo_url = dados.get("photo_url")
    content = dados.get("content")
    uid = dados.get("uid")

    print(f"dados recebidos: {dados}")
    
    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    try:
        cursor.execute("SELECT idUser, uid FROM users WHERE uid = %s", (uid,))
        user = cursor.fetchone()

        if not user:
            cursor.execute(
                "INSERT INTO users(uid, displayName, email, photoUrl) VALUES(%s, %s, %s, %s)",
                (uid, displayName, email, photo_url)
            )
            conexao.commit()
            id_user = cursor.lastrowid
        else:
            id_user = user["idUser"]

        if not id_user:
            raise Exception("Falha ao obter idUser")

        cursor.execute(
            "INSERT INTO comments(idNews, idUser, commenter, photoUrl, content, date) VALUES(%s, %s, %s, %s, %s, NOW())", 
            (id_news, id_user, displayName, photo_url, content)
        )
        conexao.commit()
        id_comment = cursor.lastrowid

        cursor.execute(
            "SELECT c.idComment, c.idUser, c.idNews, c.content, c.commenter, u.uid, DATE_FORMAT(c.date, '%Y-%m-%d %H:%i') as data " +
            "FROM comments c " +
            "JOIN users u ON c.idUser = u.idUser " +
            "WHERE c.idComment = %s", (id_comment,)
        )
        comentario = cursor.fetchone()
        resultado = jsonify(comentario)
    except Exception as e:
        conexao.rollback()
        resultado = jsonify(situacao="erro", erro=f"erro adicionando comentário: {str(e)}")

    conexao.close()

    return resultado

@servico.put("/comments/editar/<int:id_comment>")
def editar_comentario(id_comment):
    resultado = jsonify(situacao="ok", erro="", comentario={})

    dados = request.get_json()
    novo_conteudo = dados.get("content")

    print(f"dados recebidos: {dados}")
    
    conexao = get_conexao_com_bd()
    cursor = conexao.cursor(dictionary=True)
    try:
        cursor.execute(
            "UPDATE comments SET content = %s, date = NOW() WHERE idComment = %s", 
            (novo_conteudo, id_comment)
        )
        conexao.commit()
        cursor.execute(
            "SELECT c.idComment, c.idUser, c.idNews, c.content, c.commenter, u.uid, DATE_FORMAT(c.date, '%Y-%m-%d %H:%i') as data " +
            "FROM comments c " +
            "JOIN users u ON c.idUser = u.idUser " +
            "WHERE c.idComment = %s", (id_comment,)
        )
        comentario = cursor.fetchone()
        resultado = jsonify(comentario)
    except Exception as e:
        conexao.rollback()
        resultado = jsonify(situacao="erro", erro=f"erro editando comentário: {str(e)}")

    conexao.close()

    return resultado

@servico.delete("/comments/remover/<int:comentario_id>")
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