//
//  Models.swift
//  JsonRequest
//
//  Created by 王凯霖 on 2/6/21.
//

import Foundation

struct RevData: Codable {
    let results: MyResult
    let status: String
}

struct MyResult: Codable {
    let sunrise: String
    let sunset: String
    let solar_noon: String
    let day_length: String
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
}

/* Response
 {"results":
    {"sunrise":"7:14:21 AM",
    "sunset":"5:49:11 PM",
    "solar_noon":"12:31:46 PM",
    "day_length":"10:34:50",
    "civil_twilight_begin":"6:47:33 AM",
    "civil_twilight_end":"6:15:59 PM",
    "nautical_twilight_begin":"6:16:53 AM",
    "nautical_twilight_end":"6:46:39 PM",
    "astronomical_twilight_begin":"5:46:38 AM",
    "astronomical_twilight_end":"7:16:54 PM"},
 "status":"OK"}
 */
