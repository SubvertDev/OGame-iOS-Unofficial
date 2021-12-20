//
//  OGame.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import Foundation
import Alamofire
import SwiftSoup
import UIKit

class OGame {

    static let shared = OGame()

    var universe: String = ""
    private var username: String = ""
    private var password: String = ""
    private var userAgent: [String: String]?
    private var language: String?
    private var serverNumber: Int?
    private let sessionAF = Session.default
    private var token: String?

    private var attempt: Int = 0
    private var serverID: Int?
    private var tokenBearer: String?
    private var serversList: [Servers]?
    var serversOnAccount: [MyServers] = []
    private var indexPHP: String?
    private var loginLink: String?

    // These gonna change on planet change
    private var landingPage: String? // Is it?
    private var doc: Document?
    var planet: String?
    private var planetID: Int?
    private var playerName: String?
    private var playerID: Int?
    private var planetNames: [String]?
    private var planetIDs: [Int]?
    var celestial: Celestial?
    var celestials: [Celestial]?
    var planetImage: UIImage?
    private var planetImages: [UIImage] = []
    var rank: Int?
    var commander: Bool?
    
    // Necessary for build time check
    var roboticsFactoryLevel: Int?
    var naniteFactoryLevel: Int?

    private init() {}
    

    // MARK: - LOGIN FUNCTIONS -
    func loginIntoAccount(username: String, password: String, completion: @escaping (Result<Bool, OGError>) -> Void) {
        OGame.shared.reset()

        self.username = username
        self.password = password
        self.userAgent = ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1"]

        login(attempt: attempt)

        // MARK: - Login
        func login(attempt: Int) {
            let parameters = LoginData(identity: self.username,
                                       password: self.password,
                                       locale: "en_EN",
                                       gfLang: "en",
                                       platformGameId: "1dfd8e7e-6e1a-4eb1-8c64-03c3b62efd2f",
                                       gameEnvironmentId: "0a31d605-ffaf-43e7-aa02-d06df7116fc8",
                                       autoGameAccountCreation: false)

            sessionAF.request("https://gameforge.com/api/v1/auth/thin/sessions", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200...409).responseDecodable(of: Login.self) { response in

                guard response.response != nil else {
                    completion(.failure(OGError(message: "Network response error", detailed: "Try again")))
                    return
                }
                
                let statusCode = response.response!.statusCode

                switch response.result {
                case .success(_):
                    self.token = response.value!.token
                    self.attempt = 0
                    configureServers()

                case .failure(let error):
                    if statusCode == 409 && attempt < 10 {
                        let captchaToken = response.response?.headers["gf-challenge-id"]
                        let token = captchaToken!.replacingOccurrences(of: ";https://challenge.gameforge.com", with: "")
                        solveCaptcha(challenge: token)
                    } else if attempt > 10 {
                        guard statusCode != 409 else {
                            completion(.failure(OGError(message: "Captcha error", detailed: "Couldn't resolve captcha, try to solve it in browser and try again. (\(error.localizedDescription)")))
                            return
                        }
                    } else {
                        guard statusCode == 201 else {
                            completion(.failure(OGError(message: "Login error", detailed: "Check your login data and try again. (\(error.localizedDescription)")))
                            // Also called when can't captcha in
                            return
                        }
                    }
                }
            }
        }

        // MARK: - Solve Captcha
        func solveCaptcha(challenge: String) {
            let getHeaders: HTTPHeaders = ["Cookie": "", "Connection": "close"]

            sessionAF.request("https://image-drop-challenge.gameforge.com/challenge/\(challenge)/en-GB", headers: getHeaders).response { response in
                switch response.result {
                case .success(_):
                    let postHeaders: HTTPHeaders = ["Content-type": "application/json"]
                    let parameters = ["answer": 3]
                    self.sessionAF.request("https://image-drop-challenge.gameforge.com/challenge/\(challenge)/en-GB", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: postHeaders).response { response in
                        switch response.result {
                        case .success(_):
                            self.attempt += 1
                            login(attempt: self.attempt)

                        case .failure(let error):
                            completion(.failure(OGError(message: "Captcha network post error", detailed: (error.localizedDescription))))
                        }
                    }
                case .failure(let error):
                    completion(.failure(OGError(message: "Captcha network request error", detailed: error.localizedDescription)))
                }
            }
        }

        // MARK: - Configure Servers List
        func configureServers() {
            sessionAF.request("https://lobby.ogame.gameforge.com/api/servers").validate().responseDecodable(of: [Servers].self) { response in
                switch response.result {
                case .success(let servers):
                    self.serversList = servers
                    configureAccounts()

                case .failure(let error):
                    completion(.failure(OGError(message: "Server list network request error", detailed: error.localizedDescription)))
                }
            }
        }

        // MARK: - Configure Accounts
        func configureAccounts() {
            let headers: HTTPHeaders = ["authorization": "Bearer \(token!)"]

            sessionAF.request("https://lobby.ogame.gameforge.com/api/users/me/accounts", method: .get, headers: headers).validate().responseDecodable(of: [Account].self) { response in
                switch response.result {
                case .success(let accounts):
                    for account in accounts {
                        for server in self.serversList! {
                            if account.server.number == server.number && account.server.language == server.language {
                                self.serversOnAccount.append(
                                    MyServers(serverName: server.name,
                                              accountName: account.name,
                                              number: server.number,
                                              language: server.language,
                                              serverID: account.id))
                            }
                        }
                    }
                    guard !self.serversOnAccount.isEmpty else {
                        completion(.failure(OGError(message: "No servers error", detailed: "Unable to get any active servers on account, make one and/or try again")))
                        return
                    }
                    // TODO: Add accounts failure check?
                    completion(.success(true))

                case .failure(let error):
                    completion(.failure(OGError(message: "Configuration error", detailed: error.localizedDescription)))
                }
            }
        }
    }

    // MARK: - Login Into Server
    func loginIntoSever(with serverInfo: MyServers) async throws {
        serverID = serverInfo.serverID
        language = serverInfo.language
        serverNumber = serverInfo.number
        universe = serverInfo.serverName

        try await configureIndex()
        try await configureIndex2()
        try await configureIndex3()
        try await configurePlayer()

        // MARK: - Configure Index
        func configureIndex() async throws {
            indexPHP = "https://s\(serverNumber!)-\(language!).ogame.gameforge.com/game/index.php?"
            let link = "https://lobby.ogame.gameforge.com/api/users/me/loginLink?"
            let parameters: Parameters = [
                "id": "\(self.serverID!)",
                "server[language]": "\(self.language!)",
                "server[number]": "\(self.serverNumber!)",
                "clickedButton": "account_list"
            ]
            let headers: HTTPHeaders = ["authorization": "Bearer \(token!)"]

            do {
                let response = try await sessionAF.request(link, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).serializingDecodable(Index.self).value
                self.loginLink = response.url
            } catch {
                throw OGError(message: "Index page configuring error", detailed: error.localizedDescription)
            }
        }

        func configureIndex2() async throws {
            do {
                let response = try await sessionAF.request(loginLink!).serializingData().value
                self.landingPage = String(data: response, encoding: .ascii)
            } catch {
                throw OGError(message: "Landing page error", detailed: error.localizedDescription)
            }
        }

        func configureIndex3() async throws {
            do {
                let link = "\(indexPHP!)&page=ingame"
                let response = try await sessionAF.request(link).serializingData().value
                self.landingPage = String(data: response, encoding: .ascii)
            } catch {
                throw OGError(message: "Landing page error", detailed: error.localizedDescription)
            }
        }

        // MARK: - Configure Player
        func configurePlayer() async throws {
            do {
                doc = try SwiftSoup.parse(self.landingPage!)
                let planetName = try doc!.select("[name=ogame-planet-name]")
                let planetID = try doc!.select("[name=ogame-planet-id]")

                let planetNameContent = try planetName.get(0).attr("content")
                let planetIDContent = try planetID.get(0).attr("content")

                let playerName = try doc!.select("[name=ogame-player-name]").get(0).attr("content")
                let playerID = try doc!.select("[name=ogame-player-id]").get(0).attr("content")

                self.planet = planetNameContent
                self.planetID = Int(planetIDContent)
                self.playerName = playerName
                self.playerID = Int(playerID)
                self.rank = getRank()
                self.planetNames = getPlanetNames()
                self.planetIDs = getPlanetIDs()
                self.commander = getCommander()
                
                await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask {
                        let images = try await self.getAllPlanetImagesAwait()
                        self.planetImage = images[0]
                        self.planetImages = images
                    }
                    group.addTask {
                        let celestials = try await self.getAllCelestialsAwait()
                        self.celestial = celestials[0]
                        self.celestials = celestials
                    }
                    group.addTask {
                        let facilities = try await self.facilities()
                        self.roboticsFactoryLevel = facilities.roboticsFactory.level
                        self.naniteFactoryLevel = facilities.naniteFactory.level
                    }
                }
                
            } catch {
                throw OGError(message: "Player configuration error", detailed: error.localizedDescription)
            }
        }
    }


    // MARK: - NON LOGIN FUNCTIONS -
    


    // MARK: - GET RANK -> Int
    func getRank() -> Int {
        do {
            let idBar = try doc!.select("[id=bar]").get(0)
            let li = try idBar.select("li").get(1)
            let text = try li.text()

            let pattern = "\\((.*?)\\)"
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            var matches = results.map { nsString.substring(with: $0.range)}
            matches[0].removeFirst()
            matches[0].removeLast()
            let rank = matches[0]

            return Int(rank) ?? -1
        } catch {
            return -1
        }
    }


    // MARK: - PLANET IDS -> [Int]
    func getPlanetIDs() -> [Int] {
        do {
            var ids = [Int]()
            let planets = try doc!.select("[class*=smallplanet]")
            for planet in planets {
                let idAttribute = try planet.attr("id")
                let planetID = Int(idAttribute.replacingOccurrences(of: "planet-", with: ""))!
                ids.append(planetID)
            }
            return ids
        } catch {
            return [-1]
        }
    }


    // MARK: - PLANET NAMES -> [String]
    func getPlanetNames() -> [String] {
        do {
            var planetNames = [String]()
            let planets = try doc!.select("[class=planet-name]")
            for planet in planets {
                planetNames.append(try planet.text())
            }
            return planetNames
        } catch {
            return ["Error"]
        }
    }


    // MARK: - ID BY PLANET NAME -> Int
    func getIdByPlanetName(_ name: String) -> Int {
        // TODO: Better way?
        var found: Int?

        for (planetName, id) in zip(getPlanetNames(), getPlanetIDs()) {
            if planetName == name {
                found = id
            }
        }
        return found!
    }


    // MARK: - GET SERVER INFO -> Server
    func getServerInfo() -> Server {
        do {
            let version = try doc!.select("[name=ogame-version]").get(0).attr("content")

            let universe = Int(try doc!.select("[name=ogame-universe-speed]").get(0).attr("content")) ?? -1
            let fleet = Int(try doc!.select("[name=ogame-universe-speed-fleet-peaceful]").get(0).attr("content")) ?? -1
            let speed = Speed(universe: universe, fleet: fleet)

            let galaxyString = Int(try doc!.select("[name=ogame-donut-galaxy]").get(0).attr("content")) ?? 0
            let galaxy = galaxyString == 1 ? true : false
            let systemString = Int(try doc!.select("[name=ogame-donut-system]").get(0).attr("content")) ?? 0
            let system = systemString == 1 ? true : false
            let donut = Donut(galaxy: galaxy, system: system)

            return Server(version: version, speed: speed, donut: donut)
        } catch {
            return Server(version: "-1", speed: Speed(universe: -1, fleet: -1), donut: Donut(galaxy: false, system: false))
        }
    }


    // MARK: - GET CHARACTER CLASS -> String
    func getCharacterClass() -> String {
        // TODO: test on no class
        if let character = try? doc!.select("[class*=sprite characterclass medium]").get(0).className().components(separatedBy: " ").last! {
            return character
        } else {
            return "error"
        }
    }


    // MARK: - GET COMMANDER -> Bool
    func getCommander() -> Bool {
        // TODO: test on 3 days commander account
        if let commanders = try? doc!.select("[id=officers]").select("[class*=tooltipHTML  on]").select("[class*=commander]") {
            return !commanders.isEmpty() ? true : false
        } else {
            return false
        }
    }


    // MARK: - GET MOON IDS
    // TODO: Get a moon
    

    // MARK: - GET ALL CELESTIALS (NEW)
    func getAllCelestials(completion: @escaping (Result<[Celestial], OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=overview" // FIXME: Fatal error while Logout on server list loading
        
        sessionAF.request(link).validate().response { response in
            var celestials: [Celestial] = []

            switch response.result {
            case .success(let data):
                do {
                    let text = String(data: data!, encoding: .ascii)!
                    let page = try SwiftSoup.parse(text)

                    let noScript = try page.select("noscript").text()
                    guard noScript != "You need to enable JavaScript to run this app." else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Celestials login check failed")))
                        return
                    }

                    let planets = try page.select("[id=planetList]").get(0)
                    let planetsInfo = try planets.select("[id*=planet-]")
                    for planet in planetsInfo {
                        let title = try planet.select("a").get(0).attr("title")
                        let textArray = title.components(separatedBy: "><")

                        // FIXME: Not tested for moons
                        var coordinatesString = textArray[0].components(separatedBy: " ")[1].replacingOccurrences(of: "</b", with: "")
                        coordinatesString.removeFirst()
                        coordinatesString.removeLast()
                        var coordinates = coordinatesString.components(separatedBy: ":").compactMap { Int($0) }
                        coordinates.append(1)

                        var planetSizeString = textArray[1].components(separatedBy: " ")[0]
                        planetSizeString.removeFirst(4)
                        planetSizeString.removeLast(2)
                        let planetSize = Int(planetSizeString.replacingOccurrences(of: ".", with: ""))!

                        var planetFieldsString = textArray[1].components(separatedBy: " ")[1]
                        planetFieldsString = planetFieldsString.components(separatedBy: ")")[0]
                        planetFieldsString.removeFirst()
                        let planetFieldUsed = Int(planetFieldsString.components(separatedBy: "/")[0])!
                        let planetFieldTotal = Int(planetFieldsString.components(separatedBy: "/")[1])!

                        var planetMinTemperatureString = textArray[1].components(separatedBy: " ")[1]
                        planetMinTemperatureString = planetMinTemperatureString.components(separatedBy: "<br>")[1]
                        let planetMinTemperature = Int(planetMinTemperatureString.components(separatedBy: "Â")[0])!
                        let planetMaxTemperatureString = textArray[1].components(separatedBy: " ")[3]
                        let planetMaxTemperature = Int(planetMaxTemperatureString.components(separatedBy: "Â")[0])!

                        let celestial = Celestial(planetSize: planetSize,
                                                  usedFields: planetFieldUsed,
                                                  totalFields: planetFieldTotal,
                                                  tempMin: planetMinTemperature,
                                                  tempMax: planetMaxTemperature,
                                                  coordinates: coordinates)
                        celestials.append(celestial)
                    }
                } catch {
                    completion(.failure(OGError(message: "Celestialse parse error", detailed: error.localizedDescription)))
                }

            case .failure(let error):
                completion(.failure(OGError(message: "Celestials request network error", detailed: error.localizedDescription)))
            }
            self.celestial = celestials[0]
            completion(.success(celestials))
        }
    }
    
    
    func getAllCelestialsAwait() async throws -> [Celestial] {
        let link = "\(self.indexPHP!)page=ingame&component=overview" // FIXME: Fatal error while Logout on server list loading
        
        let response = try await sessionAF.request(link).serializingData().value
        var celestials: [Celestial] = []
        
        do {
            let text = String(data: response, encoding: .ascii)!
            let page = try SwiftSoup.parse(text)
            
            guard !noScriptCheck(with: page)
            else { throw OGError(message: "Not logged in", detailed: "Celestials login check failed") }
            
            let planets = try page.select("[id=planetList]").get(0)
            let planetsInfo = try planets.select("[id*=planet-]")
            for planet in planetsInfo {
                let title = try planet.select("a").get(0).attr("title")
                let textArray = title.components(separatedBy: "><")
                
                // TODO: Not tested for moons
                var coordinatesString = textArray[0].components(separatedBy: " ")[1].replacingOccurrences(of: "</b", with: "")
                coordinatesString.removeFirst()
                coordinatesString.removeLast()
                var coordinates = coordinatesString.components(separatedBy: ":").compactMap { Int($0) }
                coordinates.append(1)
                
                var planetSizeString = textArray[1].components(separatedBy: " ")[0]
                planetSizeString.removeFirst(4)
                planetSizeString.removeLast(2)
                let planetSize = Int(planetSizeString.replacingOccurrences(of: ".", with: ""))!
                
                var planetFieldsString = textArray[1].components(separatedBy: " ")[1]
                planetFieldsString = planetFieldsString.components(separatedBy: ")")[0]
                planetFieldsString.removeFirst()
                let planetFieldUsed = Int(planetFieldsString.components(separatedBy: "/")[0])!
                let planetFieldTotal = Int(planetFieldsString.components(separatedBy: "/")[1])!
                
                var planetMinTemperatureString = textArray[1].components(separatedBy: " ")[1]
                planetMinTemperatureString = planetMinTemperatureString.components(separatedBy: "<br>")[1]
                let planetMinTemperature = Int(planetMinTemperatureString.components(separatedBy: "Â")[0])!
                let planetMaxTemperatureString = textArray[1].components(separatedBy: " ")[3]
                let planetMaxTemperature = Int(planetMaxTemperatureString.components(separatedBy: "Â")[0])!
                
                let celestial = Celestial(planetSize: planetSize,
                                          usedFields: planetFieldUsed,
                                          totalFields: planetFieldTotal,
                                          tempMin: planetMinTemperature,
                                          tempMax: planetMaxTemperature,
                                          coordinates: coordinates)
                celestials.append(celestial)
            }
        } catch {
            throw OGError(message: "Celestialse parse error", detailed: error.localizedDescription)
        }
        
        self.celestial = celestials[0]
        return celestials
    }
    
    
    // MARK: - Set Next Planet
    func setNextPlanet(completion: @escaping (OGError?) -> ()) {
        if let index = planetNames!.firstIndex(of: planet!) {
            if index + 1 == planetNames!.count {
                planet = planetNames![0]
                planetID = planetIDs![0]
                celestial = celestials![0]
                planetImage = planetImages[0]
                completion(nil)
            } else {
                planet = planetNames![index + 1]
                planetID = planetIDs![index + 1]
                celestial = celestials![index + 1]
                planetImage = planetImages[index + 1]
                completion(nil)
            }
        } else {
            completion(OGError(message: "Error setting next planet", detailed: ""))
        }
    }


    // MARK: - Set Previous Planet
    func setPreviousPlanet(completion: @escaping (OGError?) -> ()) {
        if let index = planetNames!.firstIndex(of: planet!) {
            if index - 1 == -1 {
                planet = planetNames!.last
                planetID = planetIDs!.last
                celestial = celestials!.last
                planetImage = planetImages.last
                completion(nil)
            } else {
                planet = planetNames![index - 1]
                planetID = planetIDs![index - 1]
                celestial = celestials![index - 1]
                planetImage = planetImages[index - 1]
                completion(nil)
            }
        } else {
            completion(OGError(message: "Error setting previous planet", detailed: ""))
        }
    }
    
    
    // MARK: - GET PLANET IMAGES (NEW)
    func getAllPlanetImages(completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        let planets = try! doc!.select("[class*=smallplanet]")
        for planet in planets {
            dispatchGroup.enter()
            let imageAttribute = try! planet.select("[width=48]").first()!.attr("src")
            sessionAF.request("\(imageAttribute)").response { response in
                let image = UIImage(data: response.data!)
                images.append(image!)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
    
    func getAllPlanetImagesAwait() async throws -> [UIImage] {
        var images: [UIImage] = []
        let planets = try! doc!.select("[class*=smallplanet]")

        try await withThrowingTaskGroup(of: UIImage.self) { group in
            for planet in planets {
                group.addTask {
                    let imageAttribute = try! planet.select("[width=48]").first()!.attr("src")
                    let response = try await self.sessionAF.request("\(imageAttribute)").serializingData().value
                    let image = UIImage(data: response)
                    return image!
                }
            }
            for try await image in group {
                images.append(image)
            }
        }
        
        return images
    }
    
    func getImagesFromUrl(_ urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let dispatchGroup = DispatchGroup()

        for url in urls {
            dispatchGroup.enter()
            sessionAF.request(url).response { response in
                let image = UIImage(data: response.data!)
                images.append(image!)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }

    
    // MARK: - GET RESOURCES
    func getResources(completion: @escaping (Result<Resources, OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=resourceSettings&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let noScript = try page.select("noscript").text()
                    guard noScript != "You need to enable JavaScript to run this app." else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Resources login check failed")))
                        return
                    }

                    let resourceObject = Resources(from: page)
                    completion(.success(resourceObject))

                } catch {
                    completion(.failure(OGError(message: "Failed to parse resources data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Resources network request failed", detailed: error.localizedDescription)))
            }
        }
    }
    
    func getResourcesAwait() async throws -> Resources {
        let link = "\(self.indexPHP!)page=resourceSettings&cp=\(planetID!)"
        let value = try await sessionAF.request(link).serializingData().value
        
        let page = try SwiftSoup.parse(String(data: value, encoding: .ascii)!)

        guard !noScriptCheck(with: page)
        else { throw OGError(message: "Not logged in", detailed: "Resources view login check failed") }
        
        let resourceObject = Resources(from: page)
        return resourceObject
    }


    // MARK: - GET OVERVIEW
    func getOverview(completion: @escaping (Result<[Overview?], OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=overview"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                    // TODO: Countdowns are showing "load..." instead of actual time

                    let noScript = try page.select("noscript").text()
                    guard noScript != "You need to enable JavaScript to run this app." else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Overview login check failed")))
                        return
                    }

                    var overviewInfo: [Overview?] = [nil, nil, nil]

                    let buildingsParseCheck = try page.select("[id=productionboxbuildingcomponent]").get(0).select("tr").count
                    if buildingsParseCheck != 1 {
                        let buildingsParse = try page.select("[id=productionboxbuildingcomponent]").get(0)
                        let buildingName = try buildingsParse.select("tr").get(0).select("th").get(0).text()
                        let buildingLevel = try buildingsParse.select("tr").get(1).select("td").get(1).select("span").text()
                        //let buildingCountdown = try buildingsParse.select("tr").get(3).select("td").get(0).select("span").text()

                        overviewInfo[0] = Overview(buildingName: buildingName, upgradeLevel: buildingLevel)
                    }

                    let researchParseCheck = try page.select("[id=productionboxresearchcomponent]").get(0).select("tr").count
                    if researchParseCheck != 1 {
                        let researchParse = try page.select("[id=productionboxresearchcomponent]").get(0)
                        let researchName = try researchParse.select("tr").get(0).select("th").get(0).text()
                        let researchLevel = try researchParse.select("tr").get(1).select("td").get(1).select("span").text()
                        //let researchCountdown = try researchParse.select("tr").get(3).select("td").get(0).select("span").text()

                        overviewInfo[1] = Overview(buildingName: researchName, upgradeLevel: researchLevel)
                    }

                    let shipyardParseCheck = try page.select("[id=productionboxshipyardcomponent]").get(0).select("tr").count
                    if shipyardParseCheck != 1 {
                        let shipyardParse = try page.select("[id=productionboxshipyardcomponent]").get(0)
                        let shipyardName = try shipyardParse.select("tr").get(0).select("th").get(0).text()
                        let shipyardCount = try shipyardParse.select("tr").get(1).select("td").get(0).select("div").get(1).text()
                        //let shipyardCountdownNext = try shipyardParse.select("tr").get(3).select("td").get(0).select("span").text()
                        //let shipyardCountdownTotal = try shipyardParse.select("tr").get(5).select("td").get(0).select("span").text()

                        overviewInfo[2] = Overview(buildingName: shipyardName, upgradeLevel: shipyardCount)
                    }

                    completion(.success(overviewInfo))
                } catch {
                    completion(.failure(OGError(message: "Failed to parse overview data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Overview network request failed", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET SUPPLY
    func supply(completion: @escaping (Result<Supplies, OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=supplies&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let levelsParse = try page.select("span[data-value][class=level]") // + [class=amount]
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text())!)
                    }

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    //print(levels, technologyStatus)

                    guard !levels.isEmpty, !technologyStatus.isEmpty else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Supply login check failed")))
                        return
                    }

                    let suppliesObject = Supplies(levels, technologyStatus)
                    completion(.success(suppliesObject))

                } catch {
                    completion(.failure(OGError(message: "Failed to parse supplies data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Supplies network request failed", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET FACILITIES
    func facilities() async throws -> Facilities {
        let link = "\(self.indexPHP!)page=ingame&component=facilities&cp=\(planetID!)"
        let data = try await sessionAF.request(link).serializingData().value
        let page = try SwiftSoup.parse(String(data: data, encoding: .ascii)!)

        let levelsParse = try page.select("span[class=level]").select("[data-value]")
        var levels = [Int]()
        for level in levelsParse {
            levels.append(Int(try level.text())!)
        }

        let technologyStatusParse = try page.select("li[class*=technology]")
        var technologyStatus = [String]()
        for status in technologyStatusParse {
            technologyStatus.append(try status.attr("data-status"))
        }

        guard !noScriptCheck(with: page)
        else { throw OGError(message: "Not logged in", detailed: "Facilities login check failed") }

        let facilitiesObject = Facilities(levels, technologyStatus)
        return facilitiesObject
    }


    // MARK: - GET MOON FACILITIES
    // TODO: Get a moon


    // MARK: - GET RESEARCH
    func research(completion: @escaping (Result<Researches, OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=research&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let levelsParse = try page.select("span[class=level]").select("[data-value]")
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text().components(separatedBy: "(")[0]) ?? -1)
                    }

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }

                    guard !levels.isEmpty && !technologyStatus.isEmpty else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Research login check failed")))
                        return
                    }

                    let researchesObject = Researches(levels, technologyStatus)
                    completion(.success(researchesObject))

                } catch {
                    completion(.failure(OGError(message: "Failed to parse research data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Research network request failed", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET SHIPS
    func ships(completion: @escaping (Result<Ships, OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=shipyard&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let shipsParse = try page.select("[class=amount]").select("[data-value]") // *=amount for targetamount
                    var ships = [Int]()
                    for ship in shipsParse {
                        ships.append(Int(try ship.text())!)
                    }

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }

                    guard !ships.isEmpty else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Ships login check failed")))
                        return
                    }

                    let shipsObject = Ships(ships, technologyStatus)
                    completion(.success(shipsObject))

                } catch {
                    completion(.failure(OGError(message: "Failed to parse ships data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Ships network request failed", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET DEFENCES
    func defences(completion: @escaping (Result<Defences, OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=defenses&cp=\(planetID!)"
        sessionAF.request(link).validate().response  { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let defencesParse = try page.select("[class=amount]").select("[data-value]") // *=amount for targetamount
                    var defences = [Int]()
                    for defence in defencesParse {
                        defences.append(Int(try defence.text())!)
                    }

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }

                    guard !defences.isEmpty else {
                        completion(.failure(OGError(message: "Not logged in", detailed: "Defences login check failed")))
                        return
                    }

                    let defencesObject = Defences(defences, technologyStatus)
                    completion(.success(defencesObject))

                } catch {
                    completion(.failure(OGError(message: "Failed to parse defences data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Defences network request failed", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET ALLY


    // MARK: - GET SLOT -> Slot
    func getSlotCelestial() -> Slot {
        do {
            let slots = try doc!.select("[class=textCenter]").get(1).text().components(separatedBy: " ")[0].components(separatedBy: "/").compactMap { Int($0) }
            return Slot.init(with: slots)
        } catch {
            return Slot.init(with: [0, 0])
        }
    }


    // MARK: - GET FLEET (NEW)
    func getFleet(completion: @escaping (Result<[Fleets], OGError>) -> Void) {
        var fleets = [Fleets]()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getHostileFleet { result in
            switch result {
            case .success(let hostileFleet):
                fleets.append(contentsOf: hostileFleet)
                
            case .failure(let error):
                completion(.failure(OGError(message: "Error getting hostile fleet", detailed: error.localizedDescription)))
            }
            dispatchGroup.leave()
        }
                
        dispatchGroup.enter()
        getFriendlyFleet { result in
            switch result {
            case .success(let friendlyFleet):
                fleets.append(contentsOf: friendlyFleet)
                
            case .failure(let error):
                completion(.failure(OGError(message: "Error getting friendly fleet", detailed: error.localizedDescription)))
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(fleets))
        }
    }


    // MARK: - GET HOSTILE FLEET
    func getHostileFleet(completion: @escaping (Result<[Fleets], OGError>) -> Void) {
        let link = "\(indexPHP!)page=componentOnly&component=eventList"
        sessionAF.request(link).response { response in
            
            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let eventFleetParse = try page.select("[class=eventFleet]").select("[class*=hostile]")
                    let eventFleet = Elements()
                    for event in eventFleetParse {
                        if let fleet = event.parent()?.parent() {
                            eventFleet.add(fleet)
                        }
                    }

                    var fleetIDs = [Int]()
                    var arrivalTimes = [Int]()
                    var playerNames = [String]()
                    var playerIDs = [Int]()
                    var playerPlanet = [String]()
                    var enemyPlanet = [String]()
                    
                    var playerPlanetImageUrl = [String]()
                    var enemyPlanetImageUrl = [String]()
                    
                    var playerPlanetImages = [UIImage]()
                    var enemyPlanetImages = [UIImage]()

                    for event in eventFleet {
                        fleetIDs.append(Int(try event.attr("id").replacingOccurrences(of: "eventRow-", with: ""))!)
                        arrivalTimes.append(Int(try event.attr("data-arrival-time"))!)
                        playerNames.append(try event.select("[class*=sendMail ]").attr("title"))
                        playerIDs.append(Int(try event.select("[class*=sendMail ]").attr("data-playerid"))!)
                        playerPlanet.append(try event.select("[class=destFleet]").text())
                        enemyPlanet.append(try event.select("[class=originFleet]").text())
                        
                        playerPlanetImageUrl.append(try event.select("[class=origin fixed]").select("[class*=tooltipHTML]").attr("src"))
                        enemyPlanetImageUrl.append(try event.select("[class=destination fixed]").select("[class*=tooltipHTML]").attr("src"))
                    }

                    let destinations = self.getFleetCoordinates(details: eventFleet, type: "destCoords")
                    let origins = self.getFleetCoordinates(details: eventFleet, type: "coordsOrigin")

                    var fleets: [Fleets] = []
                    
                    guard !fleetIDs.isEmpty else {
                        completion(.success(fleets))
                        return
                    }
                    
                    let dispatchGroup = DispatchGroup()
                    dispatchGroup.enter()
                    self.getImagesFromUrl(playerPlanetImageUrl) { images in
                        playerPlanetImages.append(contentsOf: images)
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    self.getImagesFromUrl(enemyPlanetImageUrl) { images in
                        enemyPlanetImages.append(contentsOf: images)
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        for i in 0...fleetIDs.count - 1 {
                            let fleet = Fleets(id: fleetIDs[i],
                                               mission: "Attacked",
                                               diplomacy: "hostile",
                                               playerName: self.playerName!,
                                               playerID: self.playerID!,
                                               playerPlanet: playerPlanet[i],
                                               playerPlanetImage: playerPlanetImages[i],
                                               enemyName: playerNames[i],
                                               enemyID: playerIDs[i],
                                               enemyPlanet: enemyPlanet[i],
                                               enemyPlanetImage: enemyPlanetImages[i],
                                               returns: false,
                                               arrivalTime: arrivalTimes[i],
                                               endTime: nil,
                                               origin: origins[i],
                                               destination: destinations[i])
                            fleets.append(fleet)
                        }
                        completion(.success(fleets))
                    }

                } catch {
                    completion(.failure(OGError(message: "Hostile fleet parse error", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Get hostile fleet error", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET FRIENDLY FLEET
    func getFriendlyFleet(completion: @escaping (Result<[Fleets], Error>) -> Void) {
        let link = "\(indexPHP!)page=ingame&component=movement"
        sessionAF.request(link).response { response in
            
            switch response.result {
            case .success(let data):
                do {
                    let page = try! SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let fleetDetails = try! page.select("[class*=fleetDetails]")

                    var fleetIDs = [Int]()
                    var missionTypes = [String]()
                    var missionDiplomacy = [String]()
                    var arrivalTimes = [Int]()
                    var endTimes = [Int]()
                    var returnFlights = [Bool]()
                    var playerPlanet = [String]()
                    var enemyPlanet = [String]()
                    
                    var playerPlanetImageUrl = [String]()
                    var enemyPlanetImageUrl = [String]()
                    
                    var playerPlanetImages = [UIImage]()
                    var enemyPlanetImages = [UIImage]()

                    for event in fleetDetails {
                        fleetIDs.append(Int(try event.attr("id").replacingOccurrences(of: "fleet", with: ""))!)
                        missionDiplomacy.append(try event.select("span[class*=mission]").attr("class").components(separatedBy: " ")[1])
                        missionTypes.append(try event.select("span[class*=mission]").get(0).text())
                        arrivalTimes.append(Int(try event.attr("data-arrival-time"))!)
                        endTimes.append(Int(try event.select("[data-end-time]").attr("data-end-time"))!)
                        playerPlanet.append(try event.select("[class=originPlanet]").text())
                        enemyPlanet.append(try event.select("[class=destinationData]").text().components(separatedBy: " ")[0])

                        if try event.attr("data-return-flight") == "1" {
                            returnFlights.append(true)
                        } else {
                            returnFlights.append(false)
                        }
                        
                        playerPlanetImageUrl.append(try event.select("[class=origin fixed]").select("[class*=tooltipHTML]").attr("src"))
                        enemyPlanetImageUrl.append(try event.select("[class=destination fixed]").select("[class*=tooltipHTML]").attr("src"))
                    }

                    let destinations = self.getFleetCoordinates(details: fleetDetails, type: "destinationCoords")
                    let origins = self.getFleetCoordinates(details: fleetDetails, type: "originCoords")

                    var fleets = [Fleets]()
                    
                    guard !fleetIDs.isEmpty else {
                        completion(.success(fleets))
                        return
                    }
                    
                    let dispatchGroup = DispatchGroup()
                    dispatchGroup.enter()
                    self.getImagesFromUrl(playerPlanetImageUrl) { images in
                        playerPlanetImages.append(contentsOf: images)
                        dispatchGroup.leave()
                    }
                    dispatchGroup.enter()
                    self.getImagesFromUrl(enemyPlanetImageUrl) { images in
                        enemyPlanetImages.append(contentsOf: images)
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        for i in 0...fleetIDs.count - 1 {
                            fleets.append(Fleets(id: fleetIDs[i],
                                                mission: missionTypes[i],
                                                diplomacy: missionDiplomacy[i],
                                                playerName: self.playerName!,
                                                playerID: self.playerID!,
                                                playerPlanet: playerPlanet[i],
                                                playerPlanetImage: playerPlanetImages[i],
                                                enemyName: nil,
                                                enemyID: nil,
                                                enemyPlanet: enemyPlanet[i],
                                                enemyPlanetImage: enemyPlanetImages[i],
                                                returns: returnFlights[i],
                                                arrivalTime: arrivalTimes[i],
                                                endTime: endTimes[i],
                                                origin: origins[i],
                                                destination: destinations[i]))
                        }
                        completion(.success(fleets))
                    }

                } catch {
                    completion(.failure(OGError(message: "Friendly fleet parse error", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Get friendly fleet error", detailed: error.localizedDescription)))
            }
        }
    }


    // MARK: - GET FLEET COORDINATES
    func getFleetCoordinates(details: Elements, type: String) -> [[Int]] {
        // TODO: Test with moon/expedition
        var coordinates = [[Int]]()

        for detail in details {
            var coordinateString = try! detail.select("[class*=\(type)]").text().trimmingCharacters(in: .whitespacesAndNewlines)
            coordinateString.removeFirst()
            coordinateString.removeLast()
            var coordinate = coordinateString.components(separatedBy: ":").compactMap { Int($0) }
            
            var destination = String()
            if type == "destinationCoords" {
                let figure = try! detail.select("figure")
                if figure.count == 1 {
                    destination = "expedition"
                } else {
                    destination = try! figure.get(1).select("[class*=planetIcon]").attr("class").replacingOccurrences(of: "planetIcon ", with: "")
                }
            } else {
                let figure = try! detail.select("figure").get(0)
                destination = try! figure.select("[class*=planetIcon]").attr("class").replacingOccurrences(of: "planetIcon ", with: "")
            }
            
            switch destination {
            case "expedition":
                coordinate.append(0) // expedition
            case "moon":
                coordinate.append(3) // moon
            case "tf":
                coordinate.append(2) // debris
            default:
                coordinate.append(1) // planet
            }
            
            coordinates.append(coordinate)
        }
        
        return coordinates
    }
    
    
//    func getBuildingTimeOnline(type: Int, completion: @escaping (Result<DateComponents, OGError>) -> Void) {
//        let link = "\(self.indexPHP!)page=ingame&component=technologydetails&ajax=1"
//        let parameters: Parameters = ["action": "getDetails", "technology": type]
//        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
//
//        sessionAF.request(link, method: .get, parameters: parameters, headers: headers).response { response in
//            switch response.result {
//            case .success(let data):
//                let text = String(data: data!, encoding: .ascii)!
//                let page = try! SwiftSoup.parse(text)
//
//                guard !self.noScriptCheck(with: page) else {
//                    completion(.failure(OGError(message: "Resource check failed", detailed: "Not logged in")))
//                    return
//                }
//
//                let item = try! page.select("[datetime]").attr("datetime")
//                var isoTime = item.components(separatedBy: "\"")[1]
//                isoTime.removeLast()
//
//                let timeComponents = DateComponents.durationFrom8601String(isoTime)
//                completion(.success(timeComponents!))
//
//            case .failure(let error):
//                completion(.failure(OGError(message: "Building time parse error", detailed: "\(error)")))
//            }
//        }
//    }
    
    func getBuildingTimeOffline(building: BuildingData) -> String {
        let resources = building.metal + building.crystal
        let robotics = 1 + self.roboticsFactoryLevel!
        let nanites = NSDecimalNumber(decimal: pow(2, self.naniteFactoryLevel!))
        let speed = self.getServerInfo().speed.universe
        
        var time = 0
        if building.level < 5 {
            time = Int((Double(resources) / Double((2500 * robotics * Int(truncating: nanites) * speed))) * Double(2) / Double(7 - building.level) * 3600)
        } else {
            time = Int((Double(resources) / Double((2500 * robotics * Int(truncating: nanites) * speed))) * 3600)
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: TimeInterval(time)) ?? "nil"
    }
    
    
    func getBuildingTimeOfflineAwait(building: BuildingData) -> String {
        let resources = building.metal + building.crystal
        let robotics = 1 + self.roboticsFactoryLevel!
        let nanites = NSDecimalNumber(decimal: pow(2, self.naniteFactoryLevel!))
        let speed = self.getServerInfo().speed.universe
        
        var time = 0
        if building.level < 5 {
            time = Int((Double(resources) / Double((2500 * robotics * Int(truncating: nanites) * speed))) * Double(2) / Double(7 - building.level) * 3600)
        } else {
            time = Int((Double(resources) / Double((2500 * robotics * Int(truncating: nanites) * speed))) * 3600)
        }

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: TimeInterval(time)) ?? "nil"
    }
    

    // MARK: - GET GALAXY
    func getGalaxy(coordinates: [Int], completion: @escaping (Result<[Position?], OGError>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=galaxyContent&ajax=1"
        let parameters: Parameters = ["galaxy": coordinates[0], "system": coordinates[1]]
        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
        
        struct GalaxyResponse: Codable {
            let galaxy: String
        }

        sessionAF.request(link, method: .post, parameters: parameters, headers: headers).validate().responseDecodable(of: GalaxyResponse.self) { response in
            switch response.result {
            case .success(let data):
                do {
                    let galaxyInfo = try SwiftSoup.parse(data.galaxy)
                    let players = try galaxyInfo.select("[id*=player]")
                    let alliances = try galaxyInfo.select("[id*=alliance]")

                    let imagesParse = try galaxyInfo.select("li").select("[class*=planetTooltip]")
                    var images: [String] = []
                    for image in imagesParse {
                        images.append(try image.attr("class").replacingOccurrences(of: "planetTooltip ", with: ""))
                    }

                    var playerNames = [String: String]()
                    var playerRanks = [String: Int]()
                    var playerAlliances = [String: String]()

                    for player in players {
                        let nameKey = try player.attr("id").replacingOccurrences(of: "player", with: "")
                        let nameValue = try player.select("span").text()
                        playerNames[nameKey] = nameValue

                        let rankKey = try player.attr("id").replacingOccurrences(of: "player", with: "")
                        let rankValue = Int(try player.select("a").get(0).text()) ?? 0
                        playerRanks[rankKey] = rankValue
                    }

                    for alliance in alliances {
                        let allianceKey = try alliance.attr("id").replacingOccurrences(of: "alliance", with: "")
                        let allianceValue = try alliance.select("h1").get(0).text()
                        playerAlliances[allianceKey] = allianceValue
                    }

                    var planets = [Position?]()

                    for row in try galaxyInfo.select("#galaxytable .row") {
                        let status = try row.attr("class").replacingOccurrences(of: "row ", with: "").replacingOccurrences(of: "_filter", with: "").trimmingCharacters(in: .whitespaces)
                        var planetStatus = ""
                        var playerID = 0

                        let staffCheckID = try row.select("[rel~=player[0-9]+]").attr("rel").replacingOccurrences(of: "player", with: "")

                        if status.contains("empty_filter") {
                            planets.append(nil)
                            continue
                        } else if status.count == 0 {
                            if playerRanks[staffCheckID] == -1 {
                                planetStatus = "staff"
                                playerID = Int(staffCheckID)!
                            } else {
                                planetStatus = "you"
                                playerID = self.playerID!
                                playerNames[String(playerID)] = self.playerName
                                playerRanks[String(playerID)] = self.rank
                            }
                        } else {
                            planetStatus = "\(status[status.startIndex])"

                            let player = try row.select("[rel~=player[0-9]+]").attr("rel")
                            if player.isEmpty {
                                planets.append(nil)
                                continue
                            }

                            playerID = Int(player.replacingOccurrences(of: "player", with: ""))!
                            if playerID == 99999 {
                                planets.append(nil)
                                continue
                            }
                        }

                        let planetPosition = try row.select("[class*=position]").text()
                        let planetCoordinates = [coordinates[0], coordinates[1], Int(planetPosition)!, 1]
                        let moonPosition = try row.select("[rel*=moon]").attr("rel")
                        let allianceID = try row.select("[rel*=alliance]").attr("rel").replacingOccurrences(of: "alliance", with: "")
                        let planetName = try row.select("[id~=planet[0-9]+]").select("h1").text().replacingOccurrences(of: "Planet: ", with: "")

                        var imageString = ""
                        let noNilsCount = planets.filter({ $0 != nil}).count
                        if noNilsCount == 0 {
                            imageString = images[0]
                        } else {
                            imageString = images[noNilsCount]
                        }

                        let position = Position(coordinates: planetCoordinates,
                                                planetName: planetName,
                                                playerName: playerNames[String(playerID)]!,
                                                playerID: playerID,
                                                rank: playerRanks[String(playerID)]!,
                                                status: planetStatus,
                                                moon: moonPosition != "",
                                                alliance: playerAlliances[allianceID],
                                                imageString: imageString)
                        planets.append(position)
                    }

                    completion(.success(planets))

                } catch {
                    completion(.failure(OGError(message: "Failed to parse galaxy data", detailed: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Galaxy network request failed", detailed: error.localizedDescription)))
            }
        }
    }


    // GET SPYREPORTS


    // SEND FLEET


    // RETURN FLEET


    // SEND MESSAGE


    // MARK: - BUILD BUILDING/SHIPS
    func build(what: (Int, Int, String), completion: @escaping (Result<Bool, OGError>) -> Void) {
        let build = (type: what.0, amount: what.1, component: what.2)

        let link = "\(self.indexPHP!)page=ingame&component=\(build.component)&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
            switch response.result {
            case .success(let data):
                let text = String(data: data!, encoding: .ascii)!
                // Can i just delete that below and change it to .range(of:) ?
                let pattern = "var urlQueueAdd = (.*)token=(.*)';"
                let regex = try! NSRegularExpression(pattern: pattern, options: [])
                let nsString = text as NSString
                let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                let matches = results.map { nsString.substring(with: $0.range)}
                guard !matches.isEmpty else {
                    completion(.failure(OGError(message: "Building error", detailed: "Regex matches are empty")))
                    return
                }
                let match = matches[0]

                let strIndex = match.range(of: "token=")?.upperBound
                var final = match[strIndex!...]
                final.removeLast(2)
                let buildToken = final

                let parameters: Parameters = [
                    "page": "ingame",
                    "component": build.component,
                    "modus": 1,
                    "token": buildToken,
                    "type": build.type,
                    "menge": build.amount
                ]

                self.sessionAF.request(self.indexPHP!, parameters: parameters).response { response in
                    switch response.result {
                    case .success(_):
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(OGError(message: "Building network post request error", detailed: error.localizedDescription)))
                    }
                }
            case .failure(let error):
                completion(.failure(OGError(message: "Building network get request error", detailed: error.localizedDescription)))
            }
        }
    }


    // COLLECT RUBBLE FIELD


    // RELOGIN


    // LOGOUT


    // MARK: - Reset
    func reset() {
        // TODO: Maybe recreate singleton?
        universe = ""
        username = ""
        password = ""
        userAgent = nil
        language = nil
        serverNumber = nil
        token = nil
        attempt = 0
        serverID = nil
        tokenBearer = nil
        serversList = nil
        serversOnAccount = []
        indexPHP = nil
        loginLink = nil
        landingPage = nil
        doc = nil
        planet = nil
        planetID = nil
        celestial = nil
        celestials = nil
        planetImages = []
    }
    
    func noScriptCheck(with page: Document) -> Bool {
        let noScript = try? page.select("noscript").text()
        if noScript == "You need to enable JavaScript to run this app." {
            return true
        } else {
            return false
        }
    }
}


// rank() -> String -> 999

// planetIDs() -> [Int] -> [123456, 987654]
// planetName() -> [String] -> [Homeworld, Colony]
// idByPlanetName(name) -> Int -> 123456

// getServerInfo() -> Server
// getServerInfo().version -> String -> "8.1.0"
// getServerInfo().speed.universe -> Int -> 4
// getServerInfo().speed.fleet -> Int -> 1
// getServerInfo().donut.galaxy -> Bool -> true/false
// getServerInfo().donut.system -> Bool -> true/false

// getCharacterClass() -> String -> "explorer"

// getCelestial(@) -> @Celestial
// getCelestial(@).diameter -> Int -> 12800
// getCelestial(@).used -> Int -> 21
// getCelestial(@).total -> Int -> 180
// getCelestial(@).free -> Int -> 159
// getCelestial(@).tempMin -> Int -> 10
// getCelestial(@).tempMax -> Int -> 50
// getCelestial(@).coordinates -> [Int] -> [3, 453, 10, 1]

// getCelestialCoordinates() -> [Int] -> [3, 453, 10, 1]

// getSlotCelestial() -> Slot
// getSlotCelestial().total -> Int -> 180
// getSlotCelestial().free -> Int -> 21
// getSlotCelestial().used -> Int -> 159
