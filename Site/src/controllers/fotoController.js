var fotoModel = require("../models/fotoModel");

function listarFotosDoAlbum(req, res) {
    var idAlbum = req.params.idAlbum;

    fotoModel.listarFotosDoAlbum(idAlbum)
        .then(resultado => {
            res.status(200).json(resultado);
        })
        .catch(erro => {
            console.error("ERRO AO CARREGAR FOTOS: ", erro);
            res.status(500).json({ erro: "Erro ao obter fotos" });
        });
}

function cadastrarFoto(req, res) {
    var descricao = req.body.descricao;
    var url = req.body.url;
    var fkAlbum = req.body.fkAlbum;

    fotoModel.cadastrarFoto(descricao, url, fkAlbum)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error(erro);
            res.status(500).json(erro.sqlMessage);
        });
}

function like(req, res) {
    let idFoto = req.params.idFoto;

    fotoModel.like(idFoto)
        .then(r => res.json({ ok: true }))
        .catch(e => res.status(500).json(e.sqlMessage));
}



module.exports = {
    listarFotosDoAlbum,
    cadastrarFoto,
    like
}

