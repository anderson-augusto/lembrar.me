var albumModel = require("../models/albumModel");


function listarAlbuns(req, res) {
    albumModel.listarAlbuns()
        .then(r => res.json(r))
        .catch(e => res.status(500).json(e.sqlMessage));
}


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
    curtidasPorAlbum,
    viewsLikesSemanal,
    albumMaisEngajado,
    fotoImpactante,
    albumQueMaisCresceu,
    diaMaisLembrado,
    fotosMes
}

