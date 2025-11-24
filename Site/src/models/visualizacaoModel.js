var database = require("../database/config");

function registrar(idFoto, idUsuario) {
    var instrucaoSql = `
        INSERT INTO visualizacao (idFoto, idUsuario)
        VALUES (${idFoto}, ${idUsuario});
    `;
    return database.executar(instrucaoSql);
}

function contar(idFoto) {
    var instrucaoSql = `
        SELECT COUNT(*) as qtd
        FROM visualizacao
        WHERE idFoto = ${idFoto};
    `;
    return database.executar(instrucaoSql);
}

module.exports = {
    registrar,
    contar
}
