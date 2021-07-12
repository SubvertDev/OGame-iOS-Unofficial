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
    var universe: String
    var username: String
    var password: String
    var userAgent: [String: String]?
    var proxy: String
    var language: String?
    var serverNumber: Int?
    let sessionAF = Session.default
    // session.proxies.update
    var token: String?
    
    var attempt: Int = 0
    var serverID: Int?
    var tokenBearer: String?
    var indexPHP: String?
    var planet: String?
    var planetID: Int?
    var contentsOfPage: String?
    var loginLink: String?
    var landingPage: String?
    
    var doc: Document?
    var docResources: Document?
    var docSupplies: Document?
    var docResearch: Document?
    
    var didFullInit: Bool = false {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("didFullInit"), object: nil)
        }
    }
    
    init(universe: String, username: String, password: String, token: String? = nil, userAgent: [String: String]? = nil, proxy: String = "", language: String? = nil, serverNumber: Int? = nil) {
        self.universe = universe
        self.username = username
        self.password = password
        self.userAgent = userAgent
        self.proxy = proxy
        self.language = language
        self.serverNumber = serverNumber
        //self.session.proxies.update({'https': self.proxy})
        self.token = token
        
        
        if self.userAgent == nil {
            self.userAgent = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"]
        }
        
        print("New OGame object created:\nLogin: \(username)\nUniverse: \(universe)")
        configureToken()
    }
    
    // MARK: - TOKEN
    func configureToken() {
        if token == nil {
            loginAF(attempt: attempt)
        } else {
            // do i even need this check?
            //var accountsRequest = URLRequest(url: URL(string: "https://lobby.ogame.gameforge.com/api/users/me/accounts")!)
            //accountsRequest.setValue("Bearer \(token!)", forHTTPHeaderField: "authorization")
            //let accounts = session?.dataTask(with: accountsRequest) { data, response, error in
            //    guard let data = data else {
            //        print(#function)
            //        print("DATA ERROR!")
            //        return
            //    }
            //}
        }
    }
    
    // MARK: - ALAMOFIRE SECTION
    
    // MARK: - LOGIN
    func loginAF(attempt: Int) {
        print(#function)
        let _ = sessionAF.request("https://lobby.ogame.gameforge.com/") // delete this?
        
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
                guard statusCode == 201 else { fatalError("Bad Login, Status Code Is Not 201") }
                self.token = response.value!.token
                print("TOKEN IS SET TO \(self.token!)")
                // headers update?
                self.configureServerAF()
                
            case .failure(_):
                print("Status code: \(statusCode)")
                if statusCode == 409 && attempt < 10 {
                    //print("all headers: \(response.response?.headers)")
                    let captchaToken = response.response?.headers["gf-challenge-id"]
                    //print("gf challenge id: \(captchaToken ?? "error")")
                    let token = captchaToken!.replacingOccurrences(of: ";https://challenge.gameforge.com", with: "")
                    print("captcha token: \(token)")
                    self.solveCaptcha(challenge: token)
                } else if attempt > 10 {
                    guard statusCode != 409 else { fatalError("Resolve Captcha, Status Code Is Not 409") }
                } else {
                    guard statusCode == 201 else { fatalError("Bad Login, Status Code Is Not 201") }
                }
                // TODO: refactor guards above
                //self.configureServerAF()
            }
        }
    }
    
    // MARK: - SOLVE CAPTCHA
    func solveCaptcha(challenge: String) {
        print(#function)
        let getHeaders: HTTPHeaders = [
            "Cookie": "",
            "Connection": "close"
        ]
        sessionAF.request("https://image-drop-challenge.gameforge.com/challenge/\(challenge)/en-GB", headers: getHeaders).response { response in
            switch response.result {
            case .success(_):
                print("success captcha get request")
                
                let postHeaders: HTTPHeaders = ["Content-type": "application/json"]
                let parameters = ["answer": 3]
                self.sessionAF.request("https://image-drop-challenge.gameforge.com/challenge/\(challenge)/en-GB", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: postHeaders).response { response in
                    switch response.result {
                    case .success(_):
                        print("success captcha post request")
                        self.attempt += 1
                        self.loginAF(attempt: self.attempt)
                    case .failure(_):
                        print("failure captcha post request")
                        fatalError()
                        // TODO: handle all errors
                    }
                }
            case .failure(_):
                print("failure captcha get request")
                fatalError()
            }
        }
    }
    
    
    // MARK: - CONFIGURE SERVER
    func configureServerAF() {
        print(#function)
        sessionAF.request("https://lobby.ogame.gameforge.com/api/servers").validate().responseDecodable(of: [Server].self) { response in
            
            switch response.result {
            case .success(let servers):
                for server in servers {
                    if server.name == self.universe {
                        self.serverNumber = server.number
                        print("serverNumber set to \(self.serverNumber!) with no language parameter")
                        self.configureAccountsAF()
                        break
                    } else if server.name == self.universe && self.language == nil {
                        self.serverNumber = server.number
                        print("serverNumber set to \(self.serverNumber!) with language: nil")
                        self.configureAccountsAF()
                        break
                    }
                }
                guard self.serverNumber != nil else { fatalError("UNIVESE NOT FOUND! RETURN!") }
                print("Universe found: \(self.universe)")
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    
    // MARK: - CONFIGURE ACCOUNTS
    func configureAccountsAF() {
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
                        self.configureIndexAF()
                        break
                    } else if account.server.number == self.serverNumber && self.language == nil {
                        self.serverID = account.id
                        self.language = account.server.language
                        print("Set serverID to \(self.serverID!) and Language to '\(self.language!)'")
                        self.configureIndexAF()
                        break
                    }
                }
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    
    // MARK: - CONFIGURE INDEX
    func configureIndexAF() {
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
            print("Login link: \(response.value!.url)")
            self.loginLink = response.value!.url
            self.configureIndexAF2()
        }
    }
    // MARK: - Do i even need this one?
    func configureIndexAF2() {
        print(#function)
        sessionAF.request(loginLink!).validate().response { response in
            
            switch response.result {
            case .success(let data):
                self.landingPage = String(data: data!, encoding: .ascii)
                //print("Landing page html: \(self.landingPage!)")
                self.configureIndexAF3()
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    func configureIndexAF3() {
        print(#function)
        let link = "\(indexPHP!)&page=ingame"
        print(link)
        sessionAF.request(link).validate().response { response in
            
            switch response.result {
            case .success(let data):
                self.landingPage = String(data: data!, encoding: .ascii)
                //print("Landing page html: \(self.landingPage!)")
                self.configurePlayerAF()
            case .failure(let error):
                print(error)
                fatalError()
            }
        }
    }
    
    // MARK: - CONFIGURE PLAYER
    func configurePlayerAF() {
        print(#function)
        doc = try! SwiftSoup.parse(self.landingPage!)
        let planetName = try! doc!.select("[name=ogame-planet-name]")
        let planetID = try! doc!.select("[name=ogame-planet-id]")
        
        let planetNameContent = try! planetName.get(0).attr("content")
        let planetIDContent = try! planetID.get(0).attr("content")
        
        self.planet = planetNameContent
        self.planetID = Int(planetIDContent)
        //print("Player name (planet): \(player!)")
        //print("Player id: \(playerID!)")
        didFullInit = true
    }
    
    
    
    
    // MARK: - NON LOGIN FUNCTIONS
    
    // MARK: - ATTACKED -> Escaping Bool
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
    
    
    // MARK: - NEUTRAL -> Escaping Bool
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
    
    
    // MARK: - FRIENDLY -> Escaping Bool
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
        
        var found: Int?
        
        for (planetName, id) in zip(planetNames(), planetIDs()) {
            if planetName == name {
                found = id
            }
        }
        return found!
    }
    
    // MARK: - GET SERVER INFO
    
    // MARK: - GET CHARACTER CLASS
    
    // MARK: - GET MOON IDS
    
    // MARK: - coordinates
    
    // MARK: - GET CELESTIAL DATA
    
    // MARK: - GET CELESTIAL COORDINATES
    
    // MARK: - GET PRICES
    
    // MARK: - GET RESOURCES
    func getResources(forID: Int, completion: @escaping (Result<Resources, Error>) -> Void) {
        
        let link = "\(self.indexPHP!)page=resourceSettings&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
            
            switch response.result {
            case .success(let data):
                do {
                    self.docResources = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                    
                    let noScript = try self.docResources!.select("noscript").text()
                    guard noScript != "You need to enable JavaScript to run this app." else {
                        print("LOOKS LIKE NOT LOGGED IN")
                        completion(.failure(NSError()))
                        return
                    }
                    let resourceObject = Resources(from: self.docResources!)
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
                    self.docSupplies = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                    
                    let levelsParse = try self.docSupplies!.select("span[data-value][class=level]") // + [class=amount]
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text())!)
                    }
                    print("Levels of buildings: \(levels)")
                    
                    let technologyStatusParse = try self.docSupplies!.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Status of buildings: \(technologyStatus)")
                    
                    guard !levels.isEmpty, !technologyStatus.isEmpty else {
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
        print(#function)
        // FIXME: Fix forID insertion in link
        let link = "\(self.indexPHP!)page=ingame&component=facilities&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
            
            switch response.result {
            case .success(let data):
                do {
                    self.docSupplies = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                    
                    let levelsParse = try self.docSupplies!.select("span[class=level]").select("[data-value]")
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text())!)
                    }
                    print("Levels of facilities: \(levels)")
                    
                    let technologyStatusParse = try self.docSupplies!.select("li[class*=technology]")
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
                    self.docResearch = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                    
                    let levelsParse = try self.docResearch!.select("span[class=level]").select("[data-value]")
                    var levels = [Int]()
                    for level in levelsParse {
                        levels.append(Int(try level.text())!)
                    }
                    print("Levels of researches: \(levels)")
                    
                    let technologyStatusParse = try self.docResearch!.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    print("Status of researches: \(technologyStatus)")
                    // on: can build
                    // off: disabled
                    // disabled: cannot build
                    // active: currently building
                    guard !levels.isEmpty && !technologyStatus.isEmpty else {
                        print("LOOKS LIKE NOT LOGGED IN?")
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
        let link = "\(self.indexPHP!)page=ingame&component=shipyard&cp=\(planetID!)"
        sessionAF.request(link).validate().response { response in
        
            switch response.result {
            case .success(let data):
                do {
                    self.docResearch = try SwiftSoup.parse(String(data: data!, encoding: .ascii)!)
                    
                    let shipsParse = try self.docResearch!.select("[class*=amount]").select("[data-value]")
                    var ships = [Int]()
                    for ship in shipsParse {
                        ships.append(Int(try ship.text())!)
                    }
                    //print("Amount of ships: \(ships)")
                    
                    let technologyStatusParse = try self.docResearch!.select("li[class*=technology]")
                    var technologyStatus = [String]()
                    for status in technologyStatusParse {
                        technologyStatus.append(try status.attr("data-status"))
                    }
                    //print("Tech Status: \(technologyStatus)")
                    //on: can build
                    //off: not researched / disabled
                    //disabled: not enough resources?
                    //active?
                    
                    guard !ships.isEmpty else {
                        print("LOOKS LIKE NOT LOGGED IN?")
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
    // todo: change int int string to buildings
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
                // can i just delete that below and change it to .range(of:) ?
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
    
    // MARK: - COLLECT RUBBLE FIELD
    
    // MARK: - IS LOGGED IN
    func isLoggedIn(completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = ["authorization": "Bearer \(token!)"]
        sessionAF.request("https://lobby.ogame.gameforge.com/api/users/me/accounts", headers: headers).responseJSON { response in
            //print("response is: \(response)")
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
    
    // MARK: - TEST FUNCTION
    func isAnyBuildingsConstructed(forID: Int, completion: @escaping (Result<Bool, Error>) -> Void)  {
        // TODO: i need more clever solution
        var construction = false
        
        supply(forID: forID) { result in
            switch result {
            case .success(let supplies):
                for supply in supplies.allSupplies {
                    if supply.condition == "active" {
                        construction = true
                    }
                }
                self.facilities(forID: forID) { result in
                    switch result {
                    case .success(let facilities):
                        for facility in facilities.allFacilities {
                            if facility.condition == "active" {
                                construction = true
                            }
                        }
                        completion(.success(construction))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
