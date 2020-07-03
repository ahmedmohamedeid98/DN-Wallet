//
//  TargetType.swift
//  NetworkLayerWithGenerics-IOS13
//
//  Created by Mac OS on 7/2/20.
//  Copyright © 2020 Ahmed Eid. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParameters([String: Any])
}

protocol TargetType {
    var baseURL: String          { get }
    var path   : String          { get }
    var method : HTTPMethod      { get }
    var task   : Task            { get }
    var header : [String: String]?  { get }
    var tokenRequired: Bool { get }
    var haveResponseClass: Bool { get }
}

