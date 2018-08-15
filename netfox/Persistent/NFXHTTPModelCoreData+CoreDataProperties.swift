//
//  NFXHTTPModelCoreData+CoreDataProperties.swift
//  netfox
//
//  Created by Hugo Ángeles Chávez on 8/15/18.
//  Copyright © 2018 kasketis. All rights reserved.
//
//

import Foundation
import CoreData


extension NFXHTTPModelCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NFXHTTPModelCoreData> {
        return NSFetchRequest<NFXHTTPModelCoreData>(entityName: "NFXHTTPModelCoreData")
    }

    @NSManaged public var requestUrl: String?
    @NSManaged public var requestMethod: String?
    @NSManaged public var requestCachePolicy: String?
    @NSManaged public var requestDate: NSDate?
    @NSManaged public var requestTime: String?
    @NSManaged public var requestTimeout: String?
    @NSManaged public var requestHeaders: String?
    @NSManaged public var requestBodyLength: Int32
    @NSManaged public var requestType: String?
    @NSManaged public var responseStatus: Int32
    @NSManaged public var responseType: String?
    @NSManaged public var responseDate: NSDate?
    @NSManaged public var responseTime: String?
    @NSManaged public var responseHeaders: String?
    @NSManaged public var responseBodyLength: Int32
    @NSManaged public var timeInterval: Float
    @NSManaged public var randomHash: String?
    @NSManaged public var shortType: String?
    @NSManaged public var noResponse: Bool

}
