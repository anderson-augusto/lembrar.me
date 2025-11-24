var albumModel = require("../models/albumModel");

function listarAlbuns(req, res) {
    albumModel.listarAlbuns()
        .then(resultado => {
            if (resultado.length >= 1) {
                res.status(200).json(resultado);
            } else {
                res.status(204).send("Nenhum álbum encontrado");
            }
        })
        .catch(erro => {
            console.log("ERRO", erro);
            res.status(500).json(erro.sqlMessage);
        });
}

function kpiRankingEngajamento(req, res) {
    albumModel.kpiRankingEngajamento()
        .then(resultado => {
            res.json(resultado[0]);
        })
        .catch(erro => {
            res.status(500).json(erro.sqlMessage);
        })
}

var albumModel = require("../models/albumModel");

function curtidasPorAlbum(req, res){
    albumModel.curtidasPorAlbum()
    .then(r => res.json(r))
    .catch(e => res.status(500).json(e.sqlMessage));
}

function viewsLikesSemanal(req, res){
    albumModel.viewsLikesSemanal()
    .then(r => res.json(r))
    .catch(e => res.status(500).json(e.sqlMessage));
}


//Joao
function albumMaisEngajado(req, res) {
    albumModel.albumMaisEngajado()
        .then(r => res.json(r[0]))
        .catch(e => res.status(500).json(e.sqlMessage));
}
function fotoImpactante(req, res) {
    albumModel.fotoImpactante()
        .then(r => res.json(r[0]))
        .catch(e => res.status(500).json(e.sqlMessage));
}
function albumQueMaisCresceu(req, res) {
    albumModel.albumQueMaisCresceu()
        .then(r => res.json(r[0]))
        .catch(e => res.status(500).json(e.sqlMessage));
}

function diaMaisLembrado(req, res) {
    albumModel.diaMaisLembrado()
        .then(r => res.json(r[0]))
        .catch(e => res.status(500).json(e.sqlMessage));
}

function fotosMes(req, res) {
    albumModel.fotosMes()
        .then(r => res.json(r[0]))
        .catch(e => res.status(500).json(e.sqlMessage));
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
