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

//Joao

router.get("/kpi/album-mais-engajado", albumController.albumMaisEngajado);
router.get("/kpi/foto-impactante", albumController.fotoImpactante);
router.get("/kpi/album-que-mais-cresceu", albumController.albumQueMaisCresceu);
router.get("/kpi/dia-mais-lembrado", albumController.diaMaisLembrado);
router.get("/kpi/fotos-mes", albumController.fotosMes);







module.exports = router;
