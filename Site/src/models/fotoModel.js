var database = require("../database/config");

function listarFotosDoAlbum(idAlbum) {
    var instrucaoSql = `
        SELECT 
            idFoto,
            descricao,
            dtCriacao
        FROM foto
        WHERE fkAlbum = ${idAlbum}
        ORDER BY dtCriacao DESC;
    `;
    return database.executar(instrucaoSql);
}

function cadastrarFoto(descricao, fkAlbum) {
    var instrucaoSql = `
        INSERT INTO foto (descricao, fkAlbum)
        VALUES ('${descricao}', ${fkAlbum});
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    listarFotosDoAlbum,
    cadastrarFoto
}
