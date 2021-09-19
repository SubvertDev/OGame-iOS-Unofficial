//
//  OGame.swift
//  OGame
//
//  Created by Subvert on 15.05.2021.
//

import Foundation
import Alamofire
import SwiftSoup

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
    var planetID: Int?
    var playerName: String?
    var playerID: Int?
    var planetNames: [String]?
    var planetIDs: [Int]?
    var celestial: Celestial?
    var rank: Int?

    private init() {}

    // MARK: - ALAMOFIRE SECTION
    func loginIntoAccount(username: String, password: String, completion: @escaping (Result<Bool, CustomError>) -> Void) {
        OGame.shared.reset()
        print(#function)
        self.username = username
        self.password = password
        self.userAgent = ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1"]

        login(attempt: attempt)

        // MARK: - Login
        func login(attempt: Int) {
            print(#function)
            //let _ = sessionAF.request("https://lobby.ogame.gameforge.com/") // TODO: Delete this?
            let parameters = LoginData(identity: self.username,
                                       password: self.password,
                                       locale: "en_EN",
                                       gfLang: "en",
                                       platformGameId: "1dfd8e7e-6e1a-4eb1-8c64-03c3b62efd2f",
                                       gameEnvironmentId: "0a31d605-ffaf-43e7-aa02-d06df7116fc8",
                                       autoGameAccountCreation: false)

            sessionAF.request("https://gameforge.com/api/v1/auth/thin/sessions", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200...409).responseDecodable(of: Login.self) { response in

                let statusCode = response.response!.statusCode

                switch response.result {
                case .success(let login):
                    print("Login successful, data: \(login)")
                    self.token = response.value!.token
                    print("TOKEN IS SET TO \(self.token!)")
                    self.attempt = 0
                    configureServers()

                case .failure(_):
                    print("Status code: \(statusCode)")
                    if statusCode == 409 && attempt < 10 {
                        let captchaToken = response.response?.headers["gf-challenge-id"]
                        let token = captchaToken!.replacingOccurrences(of: ";https://challenge.gameforge.com", with: "")
                        print("captcha token: \(token)")
                        solveCaptcha(challenge: token)
                    } else if attempt > 10 {
                        guard statusCode != 409 else {
                            completion(.failure(.message("Please, resolve captcha in your browser and then try again!")))
                            return
                        }
                    } else {
                        guard statusCode == 201 else {
                            completion(.failure(.message("Please, check your login data and try again!")))
                            // TODO: Also called when can't captcha in
                            return
                        }
                    }
                }
            }
        }

        // MARK: - Solve Captcha
        func solveCaptcha(challenge: String) {
            print(#function)
            let getHeaders: HTTPHeaders = [
                "Cookie": "",
                "Connection": "close"
            ]
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
                        case .failure(_):
                            completion(.failure(.message("Captcha sending error, please try again!")))
                        }
                    }
                case .failure(_):
                    completion(.failure(.message("Captcha request error, please try again!")))
                }
            }
        }

        // MARK: - Configure Servers List
        func configureServers() {
            print(#function)
            sessionAF.request("https://lobby.ogame.gameforge.com/api/servers").validate().responseDecodable(of: [Servers].self) { response in

                switch response.result {
                case .success(let servers):
                    //print("servers response: \(servers)")
                    self.serversList = servers
                    configureAccounts()

                case .failure(_):
                    completion(.failure(.message("Servers list request error, please try again!")))
                }
            }
        }

        // MARK: - Configure Accounts
        func configureAccounts() {
            print(#function)
            let headers: HTTPHeaders = ["authorization": "Bearer \(token!)"]
            sessionAF.request("https://lobby.ogame.gameforge.com/api/users/me/accounts", method: .get, headers: headers).validate().responseDecodable(of: [Account].self) { response in

                switch response.result {
                case .success(let accounts):
                    print("Accounts: \(accounts)")
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
                        completion(.failure(.message("Unable to get any active servers on account, please try again!")))
                        return
                    }
                    // TODO: Add accounts failure check?
                    completion(.success(true))
                case .failure(_):
                    completion(.failure(.message("Unable to configure account, please try again!")))
                }
            }
        }
    }

    // MARK: - Login Into Server
    func loginIntoSever(with serverInfo: MyServers, completion: @escaping (Result<Bool, NSError>) -> Void) {
        print(#function)
        serverID = serverInfo.serverID
        language = serverInfo.language
        serverNumber = serverInfo.number
        universe = serverInfo.serverName

        configureIndex()

        // MARK: - Configure Index
        func configureIndex() {
            print(#function)
            indexPHP = "https://s\(serverNumber!)-\(language!).ogame.gameforge.com/game/index.php?"
            let link = "https://lobby.ogame.gameforge.com/api/users/me/loginLink?"
            let parameters: Parameters = [
                "id": "\(self.serverID!)",
                "server[language]": "\(self.language!)",
                "server[number]": "\(self.serverNumber!)",
                "clickedButton": "account_list"
            ]

            let headers: HTTPHeaders = ["authorization": "Bearer \(token!)"]
            sessionAF.request(link, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).validate().responseDecodable(of: Index.self) { response in

                switch response.result {
                case .success(_):
                    print("Login link: \(response.value!.url)")
                    self.loginLink = response.value!.url
                    configureIndex2()

                case .failure(_):
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed configuring authorization page, please try again!"])))
                }
            }
        }

        func configureIndex2() {
            print(#function)
            sessionAF.request(loginLink!).validate().response { response in

                switch response.result {
                case .success(let data):
                    self.landingPage = String(data: data!, encoding: .ascii)
                    configureIndex3()

                case .failure(_):
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed configuring login link, please try again!"])))
                }
            }
        }

        func configureIndex3() {
            print(#function)
            let link = "\(indexPHP!)&page=ingame"
            print("Got ingame page: \(link)")
            sessionAF.request(link).validate().response { response in

                switch response.result {
                case .success(let data):
                    self.landingPage = String(data: data!, encoding: .ascii)
                    configurePlayer()

                case .failure(_):
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed configuring ingame page, please try again!"])))
                }
            }
        }

        // MARK: - Configure Player
        func configurePlayer() {
            print(#function)
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
                getCelestial { result in
                    switch result {
                    case .success(let celestial):
                        self.celestial = celestial
                        completion(.success(true))
                    case .failure(_):
                        break
                    }
                }
            } catch {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can't configure player info, please try again!"])))
            }
        }
    }

    // MARK: - NON LOGIN FUNCTIONS -

    // MARK: - Set Next Planet
    func setNextPlanet(completion: @escaping (Error?) -> ()) {
        if let index = planetNames!.firstIndex(of: planet!) {
            if index + 1 == planetNames!.count {
                planet = planetNames![0]
                planetID = planetIDs![0]
            } else {
                planet = planetNames![index + 1]
                planetID = planetIDs![index + 1]
            }

            getCelestial { result in
                switch result {
                case .success(let celestial):
                    self.celestial = celestial
                    completion(nil)
                case .failure(_):
                    completion(NSError())
                }
            }
        }
    }

    // MARK: - Set Previous Planet
    func setPreviousPlanet(completion: @escaping (Error?) -> ()) {
        if let index = planetNames!.firstIndex(of: planet!) {
            if index - 1 == -1 {
                planet = planetNames!.last
                planetID = planetIDs!.last
            } else {
                planet = planetNames![index - 1]
                planetID = planetIDs![index - 1]
            }
            
            getCelestial { result in
                switch result {
                case .success(let celestial):
                    self.celestial = celestial
                    completion(nil)
                case .failure(_):
                    completion(NSError())
                }
            }
        }
    }

    // MARK: - ATTACKED -> @Bool
    func attacked(completion: @escaping (Result<Bool, Error>) -> Void) {
        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
        let link = "\(indexPHP!)page=componentOnly&component=eventList&action=fetchEventBox&ajax=1&asJson=1"
        sessionAF.request(link, headers: headers).responseJSON { response in

            switch response.result {
            case .success(let data):
                let checkData = data as? [String: Any]
                if checkData?["hostile"] as? Int ?? 0 > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                print("error \(error)")
                completion(.failure(error))
            }
        }
    }

    // MARK: - NEUTRAL -> @Bool
    func neutral(completion: @escaping (Result<Bool, Error>) -> Void) {
        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
        let link = "\(indexPHP!)page=componentOnly&component=eventList&action=fetchEventBox&ajax=1&asJson=1"
        sessionAF.request(link, headers: headers).responseJSON { response in

            switch response.result {
            case .success(let data):
                let checkData = data as? [String: Any]
                if checkData?["neutral"] as? Int ?? 0 > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                print("error \(error)")
                completion(.failure(error))
            }
        }
    }

    // MARK: - FRIENDLY -> @Bool
    func friendly(completion: @escaping (Result<Bool, Error>) -> Void) {
        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
        let link = "\(indexPHP!)page=componentOnly&component=eventList&action=fetchEventBox&ajax=1&asJson=1"
        sessionAF.request(link, headers: headers).responseJSON { response in

            switch response.result {
            case .success(let data):
                let checkData = data as? [String: Any]
                if checkData?["friendly"] as? Int ?? 0 > 0 {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                print("error \(error)")
                completion(.failure(error))
            }
        }
    }

    // MARK: - getRank -> Int
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

    // MARK: - PLANET IMAGE DATA -> @Data?
    func getPlanetImageData(completion: @escaping (Data?) -> Void) {
        do {
            let planets = try doc!.select("[class*=smallplanet]")
            for planet in planets {
                let idAttribute = try planet.attr("id")
                let planetID = Int(idAttribute.replacingOccurrences(of: "planet-", with: ""))!
                if planetID == self.planetID {
                    let imageAttribute = try planet.select("[width=48]").first()!.attr("src")
                    sessionAF.request("\(imageAttribute)").response { response in
                        completion(response.data)
                    }
                }
            }
            completion(nil)
        } catch {
            completion(nil)
        }
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
        if let character = try? doc!.select("[class*=sprite characterclass medium]").get(0).className().components(separatedBy: " ").last! {
            return character
        } else {
            return "error"
        }
    }

    // MARK: - GET MOON IDS
    // TODO: Get a moon

    // MARK: - coordinates

    // MARK: - GET CELESTIAL DATA
    func getCelestial(completion: @escaping (Result<Celestial, Error>) -> Void) {
        print(#function)
        let link = "\(self.indexPHP!)page=ingame&component=overview&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):

                let page = try? SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                let noScript = try? page!.select("noscript").text()
                guard noScript != "You need to enable JavaScript to run this app." else {
                    print("LOOKS LIKE NOT LOGGED IN (get celestial)")
                    completion(.failure(NSError()))
                    return
                }

                let text = String(data: data!, encoding: .ascii)!

                var pattern = #"textContent\[1] = "(.*)km \(<span>(.*)<(.*)<span>(.*)<"#
                var regex = try! NSRegularExpression(pattern: pattern, options: [])
                var nsString = text as NSString
                var results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                let stringPlanetSize = results.map { nsString.substring(with: $0.range)}

                var stringSize = stringPlanetSize.first!.components(separatedBy: #" ""#)[1].components(separatedBy: " ")[0]
                stringSize.removeLast(2)
                let planetSize = Int(stringSize.replacingOccurrences(of: ".", with: ""))!
                let planetUsedFields = Int(stringPlanetSize.first!.components(separatedBy: ">")[1].components(separatedBy: "<")[0])!
                let planetTotalFields = Int(stringPlanetSize.first!.components(separatedBy: ">")[3].components(separatedBy: "<")[0])!

                // TODO: It's actually three versions? ->
                //                "textContent\[3] = "(.*) \\u00b0C \\u00e0(.*)(.*)\\"
                //                "textContent\[3] = "(.*)\\u00b0C to (.*)\\u00b0C""
                //                "textContent\[3] = "(.*) \\u00b0C (.*) (.*) \\u00b0C""
                pattern = #"textContent\[3] = "(.*)\\u00b0C (.*) (.*)""#
                regex = try! NSRegularExpression(pattern: pattern, options: [])
                nsString = text as NSString
                results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                let stringPlanetTemperature = results.map { nsString.substring(with: $0.range)}

                let stringTemperature = stringPlanetTemperature.first!.components(separatedBy: #"""#)[1]
                let planetTemperatureMin = Int(stringTemperature.components(separatedBy: "\\")[0])!
                let planetTemperatureMax = Int(stringTemperature.components(separatedBy: "to ").last!.components(separatedBy: "\\").first!)!

                let coordinates = self.getCelestialCoordinates()

                let celestial = Celestial(planetSize: planetSize,
                                          usedFields: planetUsedFields,
                                          totalFields: planetTotalFields,
                                          tempMin: planetTemperatureMin,
                                          tempMax: planetTemperatureMax,
                                          coordinates: coordinates)
                completion(.success(celestial))

            case .failure(_):
                let celestial = Celestial(planetSize: -1,
                                          usedFields: -1,
                                          totalFields: -1,
                                          tempMin: -1,
                                          tempMax: -1,
                                          coordinates: [0, 0, 0, 0])
                completion(.success(celestial))
            }
        }
    }

    // MARK: - GET CELESTIAL COORDINATES -> [Int]
    func getCelestialCoordinates() -> [Int] {
        print(#function)
        // TODO: Check if it works with 2+ planets and moons
        do {
            let page = try SwiftSoup.parse(landingPage!)
            let allCelestials = try page.select("[class*=smallplanet]")

            let selectedPlanet = try allCelestials.select("[class*=planetlink]").select("[href*=\(String(planetID!))]")
            let selectedMoon = try allCelestials.select("[class*=moonlink]").select("[href*=\(String(planetID!))]")

            // TODO: Is it even working for moons?
                if !selectedPlanet.isEmpty() {
                    var coordinates = try selectedPlanet.select("[class=planet-koords ]").get(0).text()
                    coordinates.removeFirst()
                    coordinates.removeLast()
                    var arrayOfCoordinates = coordinates.components(separatedBy: ":").compactMap { Int($0) }
                    arrayOfCoordinates.append(1)
                    return arrayOfCoordinates
                }
                if !selectedMoon.isEmpty() {
                    var coordinates = try selectedMoon.select("[class=planet-koords ]").get(0).text()
                    coordinates.removeFirst()
                    coordinates.removeLast()
                    var arrayOfCoordinates = coordinates.components(separatedBy: ":").compactMap { Int($0) }
                    arrayOfCoordinates.append(3)
                    return arrayOfCoordinates
                }
        } catch {
            return [0, 0, 0, 0]
        }
        return [0, 0, 0, 0]
    }

    // MARK: - GET RESOURCES
    func getResources(forID: Int, completion: @escaping (Result<Resources, Error>) -> Void) {
        // FIXME: Fix planetID
        let link = "\(self.indexPHP!)page=resourceSettings&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let noScript = try page.select("noscript").text()
                    guard noScript != "You need to enable JavaScript to run this app." else {
                        print("LOOKS LIKE NOT LOGGED IN (resources info)")
                        completion(.failure(NSError()))
                        return
                    }
                    let resourceObject = Resources(from: page)
                    completion(.success(resourceObject))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET SUPPLY
    func supply(forID: Int, completion: @escaping (Result<Supplies, Error>) -> Void) {
        // FIXME: Fix forID insertion in link
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
                    print("Levels of buildings: \(levels)")

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Status of buildings: \(technologyStatus)")

                    guard !levels.isEmpty, !technologyStatus.isEmpty else {
                        print("LOOKS LIKE NOT LOGGED IN (resources)")
                        completion(.failure(NSError()))
                        return
                    }
                    let suppliesObject = Supplies(levels, technologyStatus)

                    completion(.success(suppliesObject))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET FACILITIES
    func facilities(forID: Int, completion: @escaping (Result<Facilities, Error>) -> Void) {
        // FIXME: Fix forID insertion in link
        let link = "\(self.indexPHP!)page=ingame&component=facilities&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let levelsParse = try page.select("span[class=level]").select("[data-value]")
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text())!)
                    }
                    print("Levels of facilities: \(levels)")

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Status of facilities: \(technologyStatus)")

                    let facilitiesObject = Facilities(levels, technologyStatus)

                    completion(.success(facilitiesObject))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET MOON FACILITIES
    // TODO: Get a moon

    // MARK: - GET RESEARCH
    func research(forID: Int, completion: @escaping (Result<Researches, Error>) -> Void) {
        // FIXME: Fix forID insertion in link
        let link = "\(self.indexPHP!)page=ingame&component=research&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in

            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let levelsParse = try page.select("span[class=level]").select("[data-value]")
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text())!)
                    }
                    print("Levels of researches: \(levels)")

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Status of researches: \(technologyStatus)")

                    guard !levels.isEmpty && !technologyStatus.isEmpty else {
                        print("LOOKS LIKE NOT LOGGED IN (research)")
                        completion(.failure(NSError()))
                        return
                    }

                    let researchesObject = Researches(levels, technologyStatus)

                    completion(.success(researchesObject))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET SHIPS
    func ships(forID: Int, completion: @escaping (Result<Ships, Error>) -> Void) {
        // FIXME: Fix planetID
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
                    print("Amount of ships: \(ships)")

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Ships Status: \(technologyStatus)")

                    guard !ships.isEmpty else {
                        print("LOOKS LIKE NOT LOGGED IN (ships)")
                        completion(.failure(NSError()))
                        return
                    }

                    let shipsObject = Ships(ships, technologyStatus)

                    completion(.success(shipsObject))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET DEFENCES
    func defences(forID: Int, completion: @escaping (Result<Defences, Error>) -> Void) {
        // FIXME: Fix planetID
        let link = "\(self.indexPHP!)page=ingame&component=defenses&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
            switch response.result {
            case .success(let data):
                do {
                    let page = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)

                    let defencesParse = try page.select("[class=amount]").select("[data-value]") // *=amount for targetamount
                    var defences = [Int]()
                    for defence in defencesParse {
                        defences.append(Int(try defence.text())!)
                    }
                    print("Amount of defences: \(defences)")

                    let technologyStatusParse = try page.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Defences Status: \(technologyStatus)")

                    guard !defences.isEmpty else {
                        print("LOOKS LIKE NOT LOGGED IN (defences)")
                        completion(.failure(NSError()))
                        return
                    }

                    let defencesObject = Defences(defences, technologyStatus)

                    completion(.success(defencesObject))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET GALAXY
    func getGalaxy(coordinates: [Int], completion: @escaping (Result<[Position?], Error>) -> Void) {
        let link = "\(self.indexPHP!)page=ingame&component=galaxyContent&ajax=1"
        let parameters: Parameters = ["galaxy": coordinates[0], "system": coordinates[1]]
        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]

        sessionAF.request(link, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let data):
                let checkData = data as! [String: Any]
                let galaxyJson = checkData["galaxy"] as! String

                let galaxyInfo = try! SwiftSoup.parse(galaxyJson)
                let players = try! galaxyInfo.select("[id*=player]")
                let alliances = try! galaxyInfo.select("[id*=alliance]")

                let imagesParse = try! galaxyInfo.select("li").select("[class*=planetTooltip]")
                var images: [String] = []
                for image in imagesParse {
                    images.append(try! image.attr("class").replacingOccurrences(of: "planetTooltip ", with: ""))
                }

                var playerNames = [String: String]()
                var playerRanks = [String: Int]()
                var playerAlliances = [String: String]()

                for player in players {
                    let nameKey = try! player.attr("id").replacingOccurrences(of: "player", with: "")
                    let nameValue = try! player.select("span").text()
                    playerNames[nameKey] = nameValue

                    let rankKey = try! player.attr("id").replacingOccurrences(of: "player", with: "")
                    let rankValue = Int(try! player.select("a").get(0).text()) ?? -1
                    playerRanks[rankKey] = rankValue
                }

                for alliance in alliances {
                    let allianceKey = try! alliance.attr("id").replacingOccurrences(of: "alliance", with: "")
                    let allianceValue = try! alliance.select("h1").get(0).text()
                    playerAlliances[allianceKey] = allianceValue
                }

                var planets = [Position?]()

                for row in try! galaxyInfo.select("#galaxytable .row") {
                    let status = try! row.attr("class").replacingOccurrences(of: "row ", with: "").replacingOccurrences(of: "_filter", with: "").trimmingCharacters(in: .whitespaces)
                    var planetStatus = ""
                    var playerID = 0

                    let staffCheckID = try! row.select("[rel~=player[0-9]+]").attr("rel").replacingOccurrences(of: "player", with: "")

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

                        let player = try! row.select("[rel~=player[0-9]+]").attr("rel")
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

                    let planetPosition = try! row.select("[class*=position]").text()
                    let planetCoordinates = [coordinates[0], coordinates[1], Int(planetPosition)!, 1]
                    let moonPosition = try! row.select("[rel*=moon]").attr("rel")
                    let allianceID = try! row.select("[rel*=alliance]").attr("rel").replacingOccurrences(of: "alliance", with: "")
                    let planetName = try! row.select("[id~=planet[0-9]+]").select("h1").text().replacingOccurrences(of: "Planet: ", with: "")

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

            case .failure(let error):
                completion(.failure(error))
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

    // MARK: - GET FLEET
    func getFleet(completion: @escaping (Result<[Fleets], Error>) -> Void) {
        var fleets = [Fleets]()
        
//        attacked { result in
//            switch result {
//            case .success(let attacked):
//                if attacked {
//                    self.getHostileFleet { result in
//                        switch result {
//                        case .success(let hostileFleet):
//                            for fleet in hostileFleet {
//                                fleets.append(fleet)
//                            }
//
//                        case .failure(let error):
//                            completion(.failure(error))
//                        }
//                    }
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
        
        friendly { result in
            switch result {
            case .success(let friendly):
                if friendly {
                    self.getFriendlyFleet { result in
                        switch result {
                        case .success(let friendlyFleet):
                            for fleet in friendlyFleet {
                                fleets.append(fleet)
                            }
                            completion(.success(fleets))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - GET HOSTILE FLEET
    
    // TODO: UNFINISHED
    
    func getHostileFleet(completion: @escaping (Result<[Fleets], Error>) -> Void) {
        let link = "\(indexPHP!)page=componentOnly&component=eventList"
        sessionAF.request(link).response { response in
            
            switch response.result {
            case .success(let data):
                let page = try! SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                print("PAGE FOUND: \(page)")
                
                let eventFleet = try! page.select("[class=eventFleet]")
                for event in eventFleet {
                    print("EVENT DETECTED: \(event)")
                    let test = try! event.select("[class*=hostile]").get(0)
                    print("TEST EVENT DETECTED: \(test)")
                }
                
                var fleetIDs = [Int]()
                for element in eventFleet {
                    let fleetID = Int(try! element.attr("id").replacingOccurrences(of: "event-", with: ""))!
                    print("FLEETID: \(fleetID)")
                    fleetIDs.append(fleetID)
                }
                
                var arrivalTimes = [Int]()
                for event in eventFleet {
                    arrivalTimes.append(Int(try! event.attr("data-arrival-time"))!)
                    let time = Int(try! event.attr("data-arrival-time"))!
                    let date = Date(timeIntervalSince1970: TimeInterval(time))
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "d MMM yyyy HH:mm:ss Z"
                    print("ENEMY DATE ARRIVAL: \(formatter.string(from: date))")
                }
                
                let destinations = self.getFleetCoordinates(details: eventFleet, type: "destCoords")
                let origins = self.getFleetCoordinates(details: eventFleet, type: "coordsOrigin")
                
                var playerNames = [String]()
                for name in eventFleet {
                    playerNames.append(try! name.select("[class*=sendMail ]").attr("title"))
                }
                
                var playerIDs = [Int]()
                for id in eventFleet {
                    print("ERROR IS HERE: \(try! id.select("[class*=sendMail ]").attr("data-playerid"))")
                    playerIDs.append(Int(try! id.select("[class*=sendMail ]").attr("data-playerid"))!)
                }
                
                var fleet: [Fleets] = []
                for i in 0...fleetIDs.count - 1 {
                    fleet.append(Fleets(id: fleetIDs[i],
                                       mission: 1,
                                       diplomacy: "hostile",
                                       playerName: playerNames[i],
                                       playerID: playerIDs[i],
                                       returns: false,
                                       arrivalTime: arrivalTimes[i],
                                       endTime: nil,
                                       origin: origins[i],
                                       destination: destinations[i]))
                }
                completion(.success(fleet))
                
            case .failure(_):
                break
            }
        }
    }

    // MARK: - GET FRIENDLY FLEET
    func getFriendlyFleet(completion: @escaping (Result<[Fleets], Error>) -> Void) {
        let link = "\(indexPHP!)page=ingame&component=movement"
        sessionAF.request(link).response { response in
            
            switch response.result {
            case .success(let data):
                let page = try! SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
    
                let fleetDetails = try! page.select("[class*=fleetDetails]")
                var fleetIDs = [Int]()
                for element in fleetDetails {
                    fleetIDs.append(Int(try! element.attr("id").replacingOccurrences(of: "fleet", with: ""))!)
                }
                
                // 1 - attacked
                // 3 - transport
                // 4 - deployment
                // 8 - recycle/harvest
                // 15 - expedition
                var missionTypes = [Int]()
                for event in fleetDetails {
                    missionTypes.append(Int(try! event.attr("data-mission-type"))!)
                    print(missionTypes)
                }
                
                var returnFlights = [Bool]()
                for event in fleetDetails {
                    if try! event.attr("data-return-flight") == "1" {
                        returnFlights.append(true)
                    } else {
                        returnFlights.append(false)
                    }
                }
                
                var arrivalTimes = [Int]()
                var endTimes = [Int]()
                for event in fleetDetails {
                    arrivalTimes.append(Int(try! event.attr("data-arrival-time"))!)
                    let time = Int(try! event.attr("data-arrival-time"))!
                    let date = Date(timeIntervalSince1970: TimeInterval(time))
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "d MMM yyyy HH:mm:ss Z"
                    print("DATE ARRIVAL: \(formatter.string(from: date))")
                    
                    endTimes.append(Int(try! event.select("[data-end-time]").attr("data-end-time"))!)
                    let endTime = Int(try! event.select("[data-end-time]").attr("data-end-time"))!
                    let endDate = Date(timeIntervalSince1970: TimeInterval(endTime))
                    let endFormatter = DateFormatter()
                    endFormatter.timeZone = TimeZone.current
                    endFormatter.dateFormat = "d MMM yyyy HH:mm:ss Z"
                    print("DATE ENDTIME: \(formatter.string(from: endDate))")
                }
                // TODO: Make a function to convert epoch to normal time
                // if type is 1 (attacked) use ???
                // if type is 3 (transport) use endtime>arrival
                // if type is 4 (deployment) use endtime
                // if type is 8 (recycle/harvest) use endtime>arrival
                // if type is 15 (expedition) use endtime?>arrival?
                
                print("predest")
                let destinations = self.getFleetCoordinates(details: fleetDetails, type: "destinationCoords")
                let origins = self.getFleetCoordinates(details: fleetDetails, type: "originCoords")
                print("postdest")
                            
                var fleet: [Fleets] = []
                for i in 0...fleetIDs.count - 1 {
                    fleet.append(Fleets(id: fleetIDs[i],
                                       mission: missionTypes[i],
                                       diplomacy: "friendly",
                                       playerName: self.playerName!,
                                       playerID: self.playerID!,
                                       returns: returnFlights[i],
                                       arrivalTime: arrivalTimes[i],
                                       endTime: endTimes[i],
                                       origin: origins[i],
                                       destination: destinations[i]))
                }
                
                completion(.success(fleet))
                
            case .failure(_):
                break
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

    // MARK: - GET PHALANX

    // MARK: - GET SPYREPORTS

    // MARK: - SEND FLEET

    // MARK: - RETURN FLEET

    // MARK: - SEND MESSAGE

    // MARK: - BUILD BUILDING/SHIPS
    func build(what: (Int, Int, String), id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let type = what.0
        let amount = what.1
        let component = what.2
        // FIXME: fix planet id
        let link = "\(self.indexPHP!)page=ingame&component=\(component)&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
            switch response.result {
            case .success(let data):
                // TODO: this is a mess, i hate regex
                let text = String(data: data!, encoding: .ascii)!
                // Can i just delete that below and change it to .range(of:) ?
                let pattern = "var urlQueueAdd = (.*)token=(.*)';"
                let regex = try! NSRegularExpression(pattern: pattern, options: [])
                let nsString = text as NSString
                let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                let matches = results.map { nsString.substring(with: $0.range)}
                guard !matches.isEmpty else {
                    completion(.failure(NSError()))
                    return
                }
                let match = matches[0]

                let strIndex = match.range(of: "token=")?.upperBound
                var final = match[strIndex!...]
                final.removeLast(2)
                let buildToken = final
                print("Build token: \(buildToken)")

                let parameters: Parameters = [
                    "page": "ingame",
                    "component": component,
                    "modus": 1,
                    "token": buildToken,
                    "type": type,
                    "menge": amount
                ]
                self.sessionAF.request(self.indexPHP!, parameters: parameters).response { response in
                    switch response.result {
                    case .success(_):
                        completion(.success(true))
                    case .failure(let error):
                        print(error)
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    // MARK: - COLLECT RUBBLE FIELD

    // MARK: - IS LOGGED IN
    // TODO: Do I need this?
    func isLoggedIn(completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(token!)"]
        sessionAF.request("https://lobby.ogame.gameforge.com/api/users/me/accounts", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                let checkData = data as? [String: Any]
                if checkData?["error"] != nil {
                    print("error not logged in")
                    completion(false)
                    return
                }
                print("logged in!")
                completion(true)
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - RELOGIN

    // MARK: - LOGOUT

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
    }
}

// ongoing fleets
// attacked(@) -> @Bool -> true/false
// neutral(@) -> @Bool -> true/false
// friendly(@) -> @Bool -> true/false

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

enum CustomError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case .message(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
