var express = require("express");
var router = express.Router();

var fotoController = require("../controllers/fotoController");

router.get("/album/:idAlbum", function (req, res) {
    fotoController.listarFotosDoAlbum(req, res);
});

router.post("/cadastrar", function (req, res) {
    fotoController.cadastrarFoto(req, res);
});

module.exports = router;
