var database = require("../database/config");

function listarFotosDoAlbum(idAlbum) {
    var instrucaoSql = `
        SELECT 
            idFoto,
            descricao,
            url,
            dtCriacao
        FROM foto
        WHERE fkAlbum = ${idAlbum}
        ORDER BY dtCriacao DESC;
    `;
    return database.executar(instrucaoSql);
}

function cadastrarFoto(descricao, url, fkAlbum) {
    var instrucaoSql = `
        INSERT INTO foto (descricao, url, fkAlbum)
        VALUES ('${descricao}', '${url}', ${fkAlbum});
    `;
    return database.executar(instrucaoSql);
}

function like(idFoto) {
    let sql = `
        INSERT INTO curtida (idFoto, idUsuario)
        VALUES (${idFoto}, 1)
        ON DUPLICATE KEY UPDATE dtCurtida = NOW();
    `;
    return database.executar(sql);
}

module.exports = {
    listarFotosDoAlbum,
    cadastrarFoto,
    like
};

