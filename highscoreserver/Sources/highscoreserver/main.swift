import Kitura
import LoggerAPI
import HeliumLogger
import KituraStencil

HeliumLogger.use(.verbose)
let router = Router()
let highScoreRouter = HighScoreRouter()

router.setDefault(templateEngine: StencilTemplateEngine())
router.all("/highscore", middleware: BodyParser())
router.post("/highscore",handler:highScoreRouter.postScore)
router.get("/highscore.json",handler:highScoreRouter.getJSONScores)
router.get("/highscore.html",handler:highScoreRouter.getHTMLScores)

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()



