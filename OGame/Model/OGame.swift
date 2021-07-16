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
    var username: String = ""
    var password: String = ""
    var userAgent: [String: String]?
    var language: String?
    var serverNumber: Int?
    let sessionAF = Session.default
    var token: String? = nil
    
    var attempt: Int = 0
    var serverID: Int?
    var tokenBearer: String?
    var indexPHP: String?
    var loginLink: String?
    
    // These gonna change on planet change
    var planet: String?
    var planetID: Int?
    var landingPage: String?
    var doc: Document?
    var celestial: Celestial?
    
    var didFullInit: Bool = false {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("didFullInit"), object: nil)
        }
    }
    
    private init(){}
    
    // MARK: - ALAMOFIRE SECTION
    func loginIntoAccount(universe: String, username: String, password: String, completion: @escaping (String?) -> Void) {
        print(#function)
        self.universe = universe
        self.username = username
        self.password = password
        self.userAgent = ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1"]
        
        print("New OGame object created:\nLogin: \(username)\nUniverse: \(universe)")
        login(attempt: attempt)
        
        // MARK: - Login
        func login(attempt: Int) {
            print(#function)
            let _ = sessionAF.request("https://lobby.ogame.gameforge.com/") // TODO: Delete this?
            
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
                    configureServer()
                    
                case .failure(_):
                    print("Status code: \(statusCode)")
                    if statusCode == 409 && attempt < 10 {
                        let captchaToken = response.response?.headers["gf-challenge-id"]
                        let token = captchaToken!.replacingOccurrences(of: ";https://challenge.gameforge.com", with: "")
                        print("captcha token: \(token)")
                        solveCaptcha(challenge: token)
                    } else if attempt > 10 {
                        guard statusCode != 409 else {
                            completion("Please, resolve captcha in your browser and then try again!")
                            return
                        }
                    } else {
                        guard statusCode == 201 else {
                            completion("Please, check your login data and try again!")
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
                            completion("Captcha sending error, please try again!")
                        }
                    }
                case .failure(_):
                    completion("Captcha request error, please try again!")

                }
            }
        }
        
        // MARK: - Configure Server
        func configureServer() {
            print(#function)
            sessionAF.request("https://lobby.ogame.gameforge.com/api/servers").validate().responseDecodable(of: [Server].self) { response in
                
                switch response.result {
                case .success(let servers):
                    for server in servers {
                        if server.name == self.universe {
                            self.serverNumber = server.number
                            print("serverNumber set to \(self.serverNumber!) with no language parameter")
                            configureAccounts()
                            break
                        } else if server.name == self.universe && self.language == nil {
                            self.serverNumber = server.number
                            print("serverNumber set to \(self.serverNumber!) with language: nil")
                            configureAccounts()
                            break
                        }
                    }
                    guard self.serverNumber != nil else {
                        completion("Universe not found, please try again!")
                        return
                    }
                case .failure(_):
                    completion("Server list request error, please try again!")
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
                        if account.server.number == self.serverNumber && account.server.language == self.language {
                            self.serverID = account.id
                            print("Set serverID to \(account.id)")
                            configureIndex()
                            break
                        } else if account.server.number == self.serverNumber && self.language == nil {
                            self.serverID = account.id
                            self.language = account.server.language
                            print("Set serverID to \(self.serverID!) and Language to '\(self.language!)'")
                            configureIndex()
                            break
                        }
                    }
                case .failure(_):
                    completion("Unable to configure account, please try again!")
                }
            }
        }
        
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
                    completion("Failed configuring authorization page, please try again!")
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
                    completion("Failed configuring login link, please try again!")
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
                    completion("Failed configuring ingame page, please try again!")
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
                
                self.planet = planetNameContent
                self.planetID = Int(planetIDContent)
                //print("Player name (planet): \(player!)")
                //print("Player id: \(playerID!)")
                didFullInit = true
            } catch {
                completion("Can't configure player info, please try again!")
            }
        }
    }
    
    
    // MARK: - NON LOGIN FUNCTIONS
    // MARK: - ATTACKED -> @Bool
    func attacked(completion: @escaping (Result<Bool, Error>) -> Void) {
        let headers: HTTPHeaders = ["X-Requested-With": "XMLHttpRequest"]
        let link = "\(indexPHP!)page=componentOnly&component=eventList&action=fetchEventBox&ajax=1&asJson=1"
        sessionAF.request(link, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let data):
                let checkData = data as? [String: Any]
                if checkData?["hostile"] as! Int > 0 {
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
                if checkData?["neutral"] as! Int > 0 {
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
                if checkData?["friendly"] as! Int > 0 {
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
    
    
    // MARK: - RANK -> Int
    func rank() -> Int {
        let idBar = try! doc!.select("[id=bar]").get(0)
        let li = try! idBar.select("li").get(1)
        let text = try! li.text()
        
        let pattern = "\\((.*?)\\)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let nsString = text as NSString
        let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
        var matches = results.map { nsString.substring(with: $0.range)}
        matches[0].removeFirst()
        matches[0].removeLast()
        let rank = matches[0]
        
        return Int(rank)!
    }
    
    
    // MARK: - PLANET IDS -> [Int]
    func planetIDs() -> [Int] {
        var ids = [Int]()
        
        for planet in try! doc!.select("[class*=smallplanet]") {
            let idAttribute = try! planet.attr("id")
            let planetID = Int(idAttribute.replacingOccurrences(of: "planet-", with: ""))!
            ids.append(planetID)
        }
        
        return ids
    }
    
    
    // MARK: - PLANET NAMES -> [String]
    func planetNames() -> [String] {
        var planetNames = [String]()
        
        for planet in try! doc!.select("[class=planet-name]") {
            planetNames.append(try! planet.text())
        }
        
        return planetNames
    }
    
    
    // MARK: - ID BY PLANET NAME -> Int
    func idByPlanetName(_ name: String) -> Int {
        // TODO: Better way?
        var found: Int?
        
        for (planetName, id) in zip(planetNames(), planetIDs()) {
            if planetName == name {
                found = id
            }
        }
        return found!
    }
    
    
    // MARK: - GET SERVER INFO
    
    // MARK: - GET CHARACTER CLASS -> String
    func getCharacterClass() -> String {
        if let character = try? self.doc!.select("[class*=sprite characterclass medium]").get(0).className().components(separatedBy: " ").last! {
            return character
        } else {
            return "error"
        }
    }
    
    // MARK: - GET MOON IDS
    // TODO: Get a moon
    
    // MARK: - coordinates
    
    // MARK: - GET CELESTIAL DATA -> @Celestial
    func getCelestial(forID: Int, completion: @escaping (Result<Celestial, Error>) -> Void) {
        
        let link = "\(self.indexPHP!)page=ingame&component=overview&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
            
            switch response.result {
            case .success(let data):
                let text = String(data: data!, encoding: .ascii)!
                
                var pattern = #"textContent\[1] = "(.*)km \(<span>(.*)<(.*)<span>(.*)<"#
                var regex = try! NSRegularExpression(pattern: pattern, options: [])
                var nsString = text as NSString
                var results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                let stringPlanetSize = results.map { nsString.substring(with: $0.range)}
                //print("stringPlanetSize: \(stringPlanetSize)")
                
                var stringSize = stringPlanetSize.first!.components(separatedBy: #" ""#)[1].components(separatedBy: " ")[0]
                stringSize.removeLast(2)
                let planetSize = Int(stringSize.replacingOccurrences(of: ".", with: ""))!
                let planetUsedFields = Int(stringPlanetSize.first!.components(separatedBy: ">")[1].components(separatedBy: "<")[0])!
                let planetTotalFields = Int(stringPlanetSize.first!.components(separatedBy: ">")[3].components(separatedBy: "<")[0])!
                //print(planetSize, planetUsedFields, planetTotalFields)
                
                // FIXME: It's actually three versions? ->
//                "textContent\[3] = "(.*) \\u00b0C \\u00e0(.*)(.*)\\"
//                "textContent\[3] = "(.*)\\u00b0C to (.*)\\u00b0C""
//                "textContent\[3] = "(.*) \\u00b0C (.*) (.*) \\u00b0C""
                pattern = #"textContent\[3] = "(.*)\\u00b0C (.*) (.*)""#
                regex = try! NSRegularExpression(pattern: pattern, options: [])
                nsString = text as NSString
                results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                let stringPlanetTemperature = results.map { nsString.substring(with: $0.range)}
                //print("planetTemperature: \(stringPlanetTemperature)")
                
                let stringTemperature = stringPlanetTemperature.first!.components(separatedBy: #"""#)[1]
                let planetTemperatureMin = Int(stringTemperature.components(separatedBy: "\\")[0])!
                let planetTemperatureMax = Int(stringTemperature.components(separatedBy: "to ").last!.components(separatedBy: "\\").first!)!
                //print(planetTemperatureMin, planetTemperatureMax)
                
                let coordinates = self.getCelestialCoordinates()
                
                let result = Celestial(planetSize: planetSize,
                                       usedFields: planetUsedFields,
                                       totalFields: planetTotalFields,
                                       tempMin: planetTemperatureMin,
                                       tempMax: planetTemperatureMax,
                                       coordinates: coordinates)
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - GET CELESTIAL COORDINATES
    func getCelestialCoordinates() -> [Int] {
        // FIXME: Does it work for different planets? I think it isn't
        do {
            let page = try SwiftSoup.parse(landingPage!)
            var rawCoordinates = try page.select("[class*=smallplanet]").get(0).select("[class=planet-koords ]").get(0).text()
            rawCoordinates.removeFirst()
            rawCoordinates.removeLast()
            let coordinates = rawCoordinates.components(separatedBy: ":").compactMap { Int($0) }
            return coordinates
        } catch {
            return [0, 0, 0]
        }
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
    
    
    // MARK: - GET ALLY
    
    
    // MARK: - GET SLOT
    
    
    // MARK: - GET FLEET
    
    
    // MARK: - GET HOSTILE FLEET
    
    
    // MARK: - GET FRIENDLY FLEET
    
    
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
                // FIXME: this is a mess, i hate regex
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
    
    
    // MARK: - DO RESEARCH
    // TODO: Do I need this? Looks like build function can do it on its own
    
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
    
}
