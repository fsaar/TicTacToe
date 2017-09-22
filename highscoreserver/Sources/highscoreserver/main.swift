import Kitura
import LoggerAPI
import HeliumLogger
import KituraStencil

HeliumLogger.use(.entry)
let router = Router()
let highScoreRouter = HighScoreRouter()

router.setDefault(templateEngine: StencilTemplateEngine())
router.all("/highscore.json", middleware: BodyParser())
router.post("/highscore.json",handler:highScoreRouter.postScore)
router.get("/highscore.json",handler:highScoreRouter.getJSONScores)
router.get("/highscore.html",handler:highScoreRouter.getHTMLScores)

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()



