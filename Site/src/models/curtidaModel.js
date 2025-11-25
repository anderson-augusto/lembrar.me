var database = require("../database/config");

function curtir(idFoto, idUsuario) {
    var instrucaoSql = `
        INSERT IGNORE INTO curtida (idFoto, idUsuario)
        VALUES (${idFoto}, ${idUsuario});
    `;
    return database.executar(instrucaoSql);
}

function verificar(idFoto, idUsuario){
    var sql = `
        SELECT * FROM curtida
        WHERE idFoto = ${idFoto} AND idUsuario = ${idUsuario};
    `;
    return database.executar(sql);
}

function descurtir(idFoto, idUsuario) {
    var instrucaoSql = `
        DELETE FROM curtida 
        WHERE idFoto = ${idFoto}
        AND idUsuario = ${idUsuario};
    `;
    return database.executar(instrucaoSql);
}

function contar(idFoto) {
    var instrucaoSql = `
        SELECT COUNT(*) as qtd
        FROM curtida
        WHERE idFoto = ${idFoto};
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    verificar,
    curtir,
    descurtir,
    contar
}
