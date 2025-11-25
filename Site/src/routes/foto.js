var express = require("express");
var router = express.Router();

var fotoController = require("../controllers/fotoController");

// Endpoint que o front está chamando: /fotos/album/:idAlbum
router.get("/album/:idAlbum", function (req, res) {
    fotoController.listarFotosDoAlbum(req, res);
});

router.post("/cadastrar", function (req, res) {
    fotoController.cadastrarFoto(req, res);
});

module.exports = router;
