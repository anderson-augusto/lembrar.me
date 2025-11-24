var curtidaModel = require("../models/curtidaModel");

function curtir(req, res) {
    var idFoto = req.body.idFoto;
    var idUsuario = req.body.idUsuario;

    curtidaModel.curtir(idFoto, idUsuario)
        .then(resultado => res.json(resultado))
        .catch(erro => res.status(500).json(erro.sqlMessage));
}

function descurtir(req, res) {
    var idFoto = req.body.idFoto;
    var idUsuario = req.body.idUsuario;

    curtidaModel.descurtir(idFoto, idUsuario)
        .then(resultado => res.json(resultado))
        .catch(erro => res.status(500).json(erro.sqlMessage));
}

function contar(req, res) {
    var idFoto = req.params.idFoto;

    curtidaModel.contar(idFoto)
        .then(resultado => res.json(resultado[0]))
        .catch(erro => res.status(500).json(erro.sqlMessage));
}

module.exports = {
    curtir,
    descurtir,
    contar
}
