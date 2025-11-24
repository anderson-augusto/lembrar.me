var visualizacaoModel = require("../models/visualizacaoModel");

function registrar(req, res) {
    var idFoto = req.body.idFoto;
    var idUsuario = req.body.idUsuario;

    visualizacaoModel.registrar(idFoto, idUsuario)
        .then(resultado => res.json(resultado))
        .catch(erro => res.status(500).json(erro.sqlMessage));
}

function contar(req, res) {
    var idFoto = req.params.idFoto;

    visualizacaoModel.contar(idFoto)
        .then(resultado => res.json(resultado[0]))
        .catch(erro => res.status(500).json(erro.sqlMessage));
}

module.exports = {
    registrar,
    contar
}
