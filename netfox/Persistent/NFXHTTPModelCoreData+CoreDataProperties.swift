//
//  NFXHTTPModelCoreData+CoreDataProperties.swift
//  netfox
//
//  Created by Hugo Angeles Chavez on 8/16/18.
//  Copyright © 2018 kasketis. All rights reserved.
//
//

import Foundation
import CoreData

extension NFXHTTPModelCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NFXHTTPModelCoreData> {
        return NSFetchRequest<NFXHTTPModelCoreData>(entityName: "NFXHTTPModelCoreData")
    }

    @NSManaged public var noResponse: Bool
    @NSManaged public var randomHash: String?
    @NSManaged public var requestBodyLength: NSNumber?
    @NSManaged public var requestCachePolicy: String?
    @NSManaged public var requestDate: NSDate?
    @NSManaged public var requestHeaders: String?
    @NSManaged public var requestMethod: String?
    @NSManaged public var requestTime: String?
    @NSManaged public var requestTimeout: String?
    @NSManaged public var requestType: String?
    @NSManaged public var requestUrl: String?
    @NSManaged public var responseBodyLength: NSNumber?
    @NSManaged public var responseDate: NSDate?
    @NSManaged public var responseHeaders: String?
    @NSManaged public var responseStatus: NSNumber?
    @NSManaged public var responseTime: String?
    @NSManaged public var responseType: String?
    @NSManaged public var shortType: String?
    @NSManaged public var timeInterval: NSNumber?

}
