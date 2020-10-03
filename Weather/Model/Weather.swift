//
//  Weather.swift
//  WeatherApp
//
//  Created by Daniil G on 27.09.2020.
//  Copyright © 2020 Daniil G. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let cod : String?
    let message : Double?
    let cnt : Int64?
    let list : [list]?
    let city : city?
}

struct list : Decodable {
    let main : main
    let weather : [weather]
    let clouds : clouds
    let wind : wind
    let dt_txt : String
}

struct main : Decodable {
    let temp : Float? // температура
    let humidity : Int64? // влажность
}


struct weather : Decodable {
    let id : Int64?
    let main : String?
    let descr : String?
    let icon : String?
}

struct clouds : Decodable {
    let all : Int64? // облачность
}

struct wind : Decodable{
    let speed : Float? // скорость ветра
}

struct rain : Decodable {
    let threeh : Double?
}

struct city : Decodable {
    let id : Int64
    let name : String
    let coord : location
}

struct location : Decodable {
    let lat : Double
    let lon : Double
}

