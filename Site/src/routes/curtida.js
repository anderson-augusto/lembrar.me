var express = require("express");
var router = express.Router();

var curtidaController = require("../controllers/curtidaController");

router.post("/curtir", function (req, res) {
    curtidaController.curtir(req, res);
});

router.post("/descurtir", function (req, res) {
    curtidaController.descurtir(req, res);
});

router.get("/contar/:idFoto", function (req, res) {
    curtidaController.contar(req, res);
});

module.exports = router;
