var express = require("express");
var router = express.Router();

var visualizacaoController = require("../controllers/visualizacaoController");

router.post("/registrar", function (req, res) {
    visualizacaoController.registrar(req, res);
});

router.get("/contar/:idFoto", function (req, res) {
    visualizacaoController.contar(req, res);
});

module.exports = router;
