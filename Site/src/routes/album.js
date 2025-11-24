var express = require("express");
var router = express.Router();

var albumController = require("../controllers/albumController");

router.get("/", function (req, res) {
    albumController.listarAlbuns(req, res);
});

router.get("/kpi/ranking-engajamento", function (req,res){
    albumController.kpiRankingEngajamento(req,res);
});

router.get("/curtidas", albumController.curtidasPorAlbum);
router.get("/viewsLikesSemana", albumController.viewsLikesSemanal);


module.exports = router;
