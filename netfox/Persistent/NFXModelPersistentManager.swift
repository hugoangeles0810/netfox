//
//  NFXModelPersistentManager.swift
//  netfox
//
//  Created by Hugo Ángeles Chávez on 8/15/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation
import CoreData

class NFXModelPersistentManager {
    
    static let sharedInstance = NFXModelPersistentManager(dataController: NFXCoreDataController.sharedInstance)
    let dataController: NFXCoreDataController
    
    init(dataController: NFXCoreDataController) {
        self.dataController = dataController
    }

    func add(_ obj: NFXHTTPModel) {
        _ = map(model: obj)
        try? dataController.viewContext.save()
    }
    
    func clear() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NFXHTTPModelCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try dataController.viewContext.execute(deleteRequest)
            try dataController.viewContext.save()
        } catch {
            print("Error while deleting all requests")
        }
        
    }
    
    func getModels() -> [NFXHTTPModel] {
        let fetchRequest: NSFetchRequest<NFXHTTPModelCoreData>  = NFXHTTPModelCoreData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "requestDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let coreDataHttpModels = try? dataController.viewContext.fetch(fetchRequest) else {
            return Array<NFXHTTPModel>()
        }
        
        return coreDataHttpModels.map({ map(coreDataModel: $0) })
    }
    
    fileprivate func map(coreDataModel coreDataHttpModel: NFXHTTPModelCoreData) -> NFXHTTPModel {
        let model = NFXHTTPModel()
        model.requestURL = coreDataHttpModel.requestUrl
        model.requestMethod = coreDataHttpModel.requestMethod
        model.requestCachePolicy = coreDataHttpModel.requestCachePolicy
        model.requestDate = coreDataHttpModel.requestDate as Date?
        model.requestTime = coreDataHttpModel.requestTime
        model.requestTimeout = coreDataHttpModel.requestTimeout
        model.requestHeaders = parse(to: coreDataHttpModel.requestHeaders)
        model.requestBodyLength = coreDataHttpModel.requestBodyLength?.toInt()
        model.requestType = coreDataHttpModel.requestType
        model.responseStatus = coreDataHttpModel.responseStatus?.toInt()
        model.responseType = coreDataHttpModel.responseType
        model.responseDate = coreDataHttpModel.responseDate as Date?
        model.responseTime = coreDataHttpModel.responseTime
        model.responseHeaders = parse(to: coreDataHttpModel.requestHeaders)
        model.responseBodyLength = coreDataHttpModel.responseBodyLength?.toInt()
        model.timeInterval = coreDataHttpModel.timeInterval?.toFloat()
        model.randomHash = coreDataHttpModel.randomHash as NSString?
        model.shortType = (coreDataHttpModel.shortType as NSString?)!
        model.noResponse = coreDataHttpModel.noResponse
        return model
    }
    
    fileprivate func map(model: NFXHTTPModel) -> NFXHTTPModelCoreData {
        let coreDataModel = NFXHTTPModelCoreData(context: dataController.viewContext)
        
        coreDataModel.requestUrl = model.requestURL
        coreDataModel.requestMethod = model.requestMethod
        coreDataModel.requestCachePolicy = model.requestCachePolicy
        coreDataModel.requestDate = model.requestDate as NSDate?
        coreDataModel.requestTime = model.requestTime
        coreDataModel.requestTimeout = model.requestTimeout
        coreDataModel.requestHeaders = json(from: model.requestHeaders)
        coreDataModel.requestBodyLength = model.requestBodyLength?.toNSNumber()
        coreDataModel.requestType = model.requestType
        coreDataModel.responseStatus = model.responseStatus?.toNSNumber()
        coreDataModel.responseType = model.responseType
        coreDataModel.responseDate = model.responseDate as NSDate?
        coreDataModel.responseTime = model.responseTime
        coreDataModel.responseHeaders = json(from: model.responseHeaders)
        coreDataModel.responseBodyLength = model.responseBodyLength?.toNSNumber()
        coreDataModel.timeInterval = model.timeInterval?.toNSNumber()
        coreDataModel.randomHash = model.randomHash as String?
        coreDataModel.shortType = model.shortType as String?
        coreDataModel.noResponse = model.noResponse
        
        return coreDataModel
    }
    
    func json(from dict: [AnyHashable: Any]?) -> String? {
        let encoder = JSONEncoder()
        guard let dictJson = dict as? [String: String],
            let data = try? encoder.encode(dictJson) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func parse(to json: String?) -> [String: String]? {
        let decoder = JSONDecoder()
        guard let myJson = json,
            let data = myJson.data(using: .utf8),
            let dict = try? decoder.decode(Dictionary<String,String>.self, from: data) else {
            return [String: String]()
        }
        
        return dict
    }
}

extension NSNumber {
    fileprivate func toInt() -> Int {
        return Int(truncating: self)
    }
    
    fileprivate func toFloat() -> Float {
        return Float(truncating: self)
    }
}

extension Int {
    fileprivate func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Float {
    fileprivate func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

