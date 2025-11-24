var database = require("../database/config");

function listarAlbuns() {
    var instrucaoSql = `
        SELECT 
            idAlbum,
            nome,
            descricao,
            dtCriacao
        FROM album
        ORDER BY dtCriacao DESC;
    `;
    return database.executar(instrucaoSql);
}

function kpiRankingEngajamento() {
    var instrucaoSql = `
        SELECT 
            a.nome AS album,
            COUNT(v.idFoto) + COUNT(c.idFoto) AS engajamento
        FROM album a
        LEFT JOIN foto f ON f.fkAlbum = a.idAlbum
        LEFT JOIN visualizacao v ON v.idFoto = f.idFoto
        LEFT JOIN curtida c ON c.idFoto = f.idFoto
        GROUP BY a.idAlbum
        ORDER BY engajamento DESC
        LIMIT 1;
    `;
    return database.executar(instrucaoSql);
}

var database = require("../database/config");

// total de curtidas por álbum
function curtidasPorAlbum(){
    var sql = `
       SELECT a.nome,
              COUNT(c.idFoto) AS qtdCurtidas
       FROM album a
       LEFT JOIN foto f ON f.fkAlbum = a.idAlbum
       LEFT JOIN curtida c ON c.idFoto = f.idFoto
       GROUP BY a.idAlbum
       ORDER BY qtdCurtidas DESC;
    `;
    return database.executar(sql);
}

// últimas 5 semanas views e likes
function viewsLikesSemanal(){
    var sql = `
        SELECT 
            sem.semana,
            sem.views,
            COALESCE(likes.qtdLikes, 0) AS likes
        FROM (
            SELECT 
                YEARWEEK(dtVisualizacao, 1) AS semana,
                COUNT(*) AS views
            FROM visualizacao
            WHERE dtVisualizacao >= NOW() - INTERVAL 5 WEEK
            GROUP BY YEARWEEK(dtVisualizacao, 1)
        ) AS sem
        LEFT JOIN (
            SELECT 
                YEARWEEK(dtCurtida, 1) AS semana,
                COUNT(*) AS qtdLikes
            FROM curtida
            WHERE dtCurtida >= NOW() - INTERVAL 5 WEEK
            GROUP BY YEARWEEK(dtCurtida, 1)
        ) AS likes
        ON likes.semana = sem.semana
        ORDER BY sem.semana;
    `;
    return database.executar(sql);
}




module.exports = {
    listarAlbuns,
    kpiRankingEngajamento,
    curtidasPorAlbum,
   viewsLikesSemanal
}
