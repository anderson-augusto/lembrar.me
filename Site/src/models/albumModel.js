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
                WEEK(dtVisualizacao, 1) AS semana,
                COUNT(*) AS views
            FROM visualizacao
            WHERE dtVisualizacao >= NOW() - INTERVAL 5 WEEK
            GROUP BY WEEK(dtVisualizacao, 1)
        ) AS sem
        LEFT JOIN (
            SELECT 
                WEEK(dtCurtida, 1) AS semana,
                COUNT(*) AS qtdLikes
            FROM curtida
            WHERE dtCurtida >= NOW() - INTERVAL 5 WEEK
            GROUP BY WEEK(dtCurtida, 1)
        ) AS likes
        ON likes.semana = sem.semana
        ORDER BY sem.semana;

    `;
    return database.executar(sql);
}

function albumMaisEngajado() {
    const sql = `
        SELECT 
            a.idAlbum,
            a.nome,
            COUNT(DISTINCT v.idVisualizacao) +
            COUNT(DISTINCT c.idUsuario) AS engajamento
        FROM album a
        LEFT JOIN foto f ON f.fkAlbum = a.idAlbum
        LEFT JOIN visualizacao v 
            ON v.idFoto = f.idFoto 
            AND v.dtVisualizacao >= NOW() - INTERVAL 30 DAY
        LEFT JOIN curtida c 
            ON c.idFoto = f.idFoto
            AND c.dtCurtida >= NOW() - INTERVAL 30 DAY
        GROUP BY a.idAlbum
        ORDER BY engajamento DESC
        LIMIT 1;
    `;
    return database.executar(sql);
}

function fotoImpactante() {
    const sql = `
        SELECT 
            f.idFoto,
            f.descricao,
            (COUNT(DISTINCT c.idUsuario) / NULLIF(COUNT(DISTINCT v.idVisualizacao), 0)) AS taxa
        FROM foto f
        LEFT JOIN curtida c 
            ON c.idFoto = f.idFoto
            AND c.dtCurtida >= NOW() - INTERVAL 30 DAY
        LEFT JOIN visualizacao v
            ON v.idFoto = f.idFoto
            AND v.dtVisualizacao >= NOW() - INTERVAL 30 DAY
        GROUP BY f.idFoto
        HAVING taxa IS NOT NULL
        ORDER BY taxa DESC
        LIMIT 1;
    `;
    return database.executar(sql);
}

function albumQueMaisCresceu() {
    const sql = `
        WITH ultimas AS (
            SELECT 
                a.idAlbum,
                COUNT(v.idVisualizacao) AS viewsRecentes
            FROM album a
            LEFT JOIN foto f ON f.fkAlbum = a.idAlbum
            LEFT JOIN visualizacao v ON v.idFoto = f.idFoto
                AND v.dtVisualizacao >= NOW() - INTERVAL 30 DAY
            GROUP BY a.idAlbum
        ),
        anteriores AS (
            SELECT 
                a.idAlbum,
                COUNT(v.idVisualizacao) AS viewsAntigas
            FROM album a
            LEFT JOIN foto f ON f.fkAlbum = a.idAlbum
            LEFT JOIN visualizacao v ON v.idFoto = f.idFoto
                AND v.dtVisualizacao BETWEEN 
                    NOW() - INTERVAL 60 DAY AND NOW() - INTERVAL 30 DAY
            GROUP BY a.idAlbum
        )
        SELECT 
            u.idAlbum,
            a.nome,
            u.viewsRecentes,
            an.viewsAntigas,
            (u.viewsRecentes - an.viewsAntigas) AS crescimento
        FROM ultimas u
        JOIN album a ON a.idAlbum = u.idAlbum
        LEFT JOIN anteriores an ON an.idAlbum = u.idAlbum
        ORDER BY crescimento DESC
        LIMIT 1;
    `;
    return database.executar(sql);
}
function diaMaisLembrado() {
    const sql = `
        SELECT 
    DATE(f.dtCriacao) AS dia,
    COUNT(*) AS total
        FROM foto f
        GROUP BY DATE(f.dtCriacao)
        ORDER BY total DESC
        LIMIT 1;
    `;
    return database.executar(sql);
}
function fotosMes() {
    const sql = `
        SELECT COUNT(*) AS total
        FROM foto
        WHERE dtCriacao >= NOW() - INTERVAL 30 DAY;
    `;
    return database.executar(sql);
}

module.exports = {
    listarAlbuns,
    kpiRankingEngajamento,
    curtidasPorAlbum,
    viewsLikesSemanal,
    albumMaisEngajado,
    fotoImpactante,
    albumQueMaisCresceu,
    diaMaisLembrado,
    fotosMes
}
