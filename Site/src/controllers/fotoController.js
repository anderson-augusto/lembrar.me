var fotoModel = require("../models/fotoModel");

function listarFotosDoAlbum(req, res) {
    var idAlbum = req.params.idAlbum;

    fotoModel.listarFotosDoAlbum(idAlbum)
        .then(resultado => {
            res.status(200).json(resultado);
        })
        .catch(erro => {
            res.status(500).json(erro.sqlMessage);
        });
}

function cadastrarFoto(req, res) {
    var descricao = req.body.descricao;
    var fkAlbum = req.body.fkAlbum;

    fotoModel.cadastrarFoto(descricao, fkAlbum)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    listarFotosDoAlbum,
    cadastrarFoto
}
