//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 12/20/20.
//


import Foundation
import Fluent
import Vapor

enum WagerGrade: String, Content {
    case win, lose, push, pending, cancelled
}

enum WagerType: String, Content {
    case moneyline, spread, total
}

enum WagerTotal: String, Content {
    case over, under, draw
}

final class Wager: Model, Content {
    static let schema = "wagers"
    
    @ID(key: .id)
    var id: UUID?
    
    /// moneyline, spread, or total
    @Enum(key: "type")
    var type: WagerType
    
    @Parent(key: "game")
    var game: Game
    
    @Parent(key: "contest")
    var contest: Contest
    
    /// The wager amount
    @Field(key: "amount")
    var amount: Float
    
    /// The amount the user will win
    @Field(key: "toWin")
    var toWin: Float
    
    /// The odds for the bet. For moneyline this is also the value
    @Field(key: "odds")
    var odds: Int
    
    /// The value for spread or total
    @Field(key: "value")
    var value: Float
    
    /// over, under, or draw
    @Enum(key: "total")
    var total: WagerTotal
    
    @Enum(key: "grade")
    var grade: WagerGrade
    
    private func roundToPlaces(value:Float, places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return round(value * divisor) / divisor
    }
    
    func calculateWinnings() -> Float {
        var multiplier: Float = 0.0
        if self.odds >= 100 {
            multiplier = Float(Float(odds)/100)
            return amount * multiplier
        } else {
            let val = amount * 100
            let absodd = Float(abs(Int32(odds)))
            let returnable = val/absodd
            return returnable
        }
    }
    
    init() { }
    
    
    
}
