//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    //Get value in usd
    var usd = getUSDValue(cur: Money(amount: self.amount,currency: self.currency))
    //Change to other currency
    usd.currency = to
    //Get conversion value of currency
    return Money(amount: getCurValue(cur: usd),currency: to)
    
  }
  
  public func add(_ to: Money) -> Money {
    let initalValue = getUSDValue(cur: self).amount
    let addValue = getUSDValue(cur: to).amount
    
    return Money(amount: (initalValue + addValue), currency: "USD").convert(to.currency)
    
  }
  public func subtract(_ from: Money) -> Money {
    let initalValue = getUSDValue(cur: from).amount
    let subtractValue = getUSDValue(cur: self).amount
    return Money(amount: (initalValue - subtractValue), currency: "USD").convert(from.currency)
  }
    
   private func getUSDValue(cur: Money) -> Money {
    
    switch cur.currency{
    case "GBP":
        return Money(amount: cur.amount * 2,currency: "USD")
    case "EUR":
        return Money(amount: Int(Double(cur.amount) / 1.5),currency: "USD")
    case "CAN":
        return  Money(amount: Int(Double(cur.amount) / 1.25),currency: "USD")
    default:
        return cur
    }

    }
    private func getCurValue(cur: Money) -> Int{
        switch cur.currency{
        case "GBP":
            return Int(Double(cur.amount) / 2)
        case "EUR":
            return Int(Double(cur.amount) * 1.5)
        case "CAN":
            return  Int(Double(cur.amount) * 1.25)
        default:
            return cur.amount
        }
    }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    
    switch type{
    case .Hourly(let num):
        return( Int(Double(hours) * num))
    
    case .Salary(let num):
        return( num)
    
    }
  }
  
  open func raise(_ amt : Double) {
    switch type{
    case .Hourly(let num):
        self.type = .Hourly( num + amt)
        
    case .Salary(let num):
        self.type = .Salary(num + Int(amt) )
        
    }
    
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {return _job}
    set(newJob) {
        if( self.age > 16){
        _job = newJob
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {return _spouse }
    set(newSpouse) {
        if( self.age > 16){
        _spouse = newSpouse
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    var string = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age)"
    
    if job != nil{
        string = string + " job:\(self.job!.title)"
    }else{
        string = string + " job:nil"
    }
    
    if(spouse != nil){
        string = string + " spouse:\(self.spouse!.firstName)"
    }else{
        string = string + " spouse:nil"
    }

    return string + "]"
  }
}


////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = nil
    spouse2.spouse = nil
    
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    
    self.members.append(spouse1)
    self.members.append(spouse2)
    
  }
  
  open func haveChild(_ child: Person) -> Bool {
    
    var ageBool = false
    
    for member in members{
        if member.age >= 21{
            ageBool = true
            self.members.append(child)
            break
        }
    }
    
    return ageBool
    
  }
  
  open func householdIncome() -> Int {
    
    var householdIncome = 0
    for member in members{
        if member.job != nil{
        householdIncome += member.job!.calculateIncome(2000)
        }
    }
    
    return householdIncome
  }
}






