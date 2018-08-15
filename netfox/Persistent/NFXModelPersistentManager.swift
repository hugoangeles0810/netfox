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
        model.requestDate = coreDataHttpModel.requestDate
        model.requestTime = coreDataHttpModel.requestTime
        model.requestTimeout = coreDataHttpModel.requestTimeout
        model.requestHeaders = [AnyHashable: Any]() // TODO: Change this
        model.requestBodyLength = coreDataHttpModel.requestBodyLength?.toInt()
        model.requestType = coreDataHttpModel.requestType
        model.responseStatus = coreDataHttpModel.responseStatus?.toInt()
        model.responseType = coreDataHttpModel.responseType
        model.responseDate = coreDataHttpModel.responseDate
        model.responseTime = coreDataHttpModel.responseTime
        model.responseHeaders = [AnyHashable: Any]() // TODO: Change this
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
        coreDataModel.requestDate = model.requestDate
        coreDataModel.requestTime = model.requestTime
        coreDataModel.requestTimeout = model.requestTimeout
        coreDataModel.requestHeaders = nil // TODO: Change this
        coreDataModel.requestBodyLength = model.requestBodyLength?.toNSNumber()
        coreDataModel.requestType = model.requestType
        coreDataModel.responseStatus = model.responseStatus?.toNSNumber()
        coreDataModel.responseType = model.responseType
        coreDataModel.responseDate = model.responseDate
        coreDataModel.responseTime = model.responseTime
        coreDataModel.responseHeaders = nil // TODO: Change this
        coreDataModel.responseBodyLength = model.responseBodyLength?.toNSNumber()
        coreDataModel.timeInterval = model.timeInterval?.toNSNumber()
        coreDataModel.randomHash = model.randomHash as String?
        coreDataModel.shortType = model.shortType as String?
        coreDataModel.noResponse = model.noResponse
        
        return coreDataModel
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

