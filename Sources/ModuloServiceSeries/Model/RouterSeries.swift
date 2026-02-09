//
//  RouterMovie.swift
//  ModuloServiceSeries
//
//  Created by Andre  Haas on 09/02/26.
//


public enum RouterSeries: String {
    case airingToday =  "airing_today"
    case onTheAir = "on_the_air"
    case popular = "popular"
    case topRated = "top_rated"
    
    func path() -> String {
        return rawValue
    }
}
