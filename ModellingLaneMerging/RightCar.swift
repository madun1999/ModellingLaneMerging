//
//  RightCar.swift
//  ModellingLaneMerging
//
//  Created by Dun Ma on 15/11/12.
//  Copyright (c) 2015年 Dun Ma. All rights reserved.
//

import Foundation

class RightCar {
    
    init(spee:Float, mergedis:Float, ind:Int,dis:Float, person:Float, maxs:Float){
        speed = spee
        distance = dis
        mergedistance = mergedis
        index = ind
        rightlaneindex = ind/2 - 1
        personality = person
        maxspee = maxs
    }
    
    var speed:Float
    var xcor:Float = 30
    var distance:Float
    var mergedistance:Float
    let exp = 2.718
    var index:Int
    var rage:Float = 0
    var leftlaneindex:Int = -1
    var rightlaneindex:Int
    let maxacc:Float = 0.1
    var maxspee:Float = 1.6
    var hornlevel:Float = 1
    var signlevel:Int = 0
    var wait:Int = 0
    var personality: Float = 0
    /*0-stay on the right, 1-try to merge, 2-merging, 3-stay on the left, 4-passed*/
    var state:Int = 0
    
    func frame(_ frontd:Float, fronts:Float) -> (Float,Float,Float){
        if distance <= 0{
            distance = 0
            return (speed,xcor,distance)
        }
        if rage <= 0 || distance >= 200 {
            rage = 0
        }
        if state == 2{
            xcor = (Float(Double(xcor+30)/exp-30)-xcor)/10 + xcor
            cruise(fronts,distanc:frontd)
            if distance <= 5{
                xcor -=  1.2
            }
            if Int(xcor) <= -20 {xcor = -30 ; state = 3;rage -= 40; return(speed,101,distance)}
            return(speed,xcor,distance)
        }
        if state == 0 && mergedistance >= distance{
            state = 1
            return (0,401,distance)
        }
        if state == 1{
            return (0,402,distance)
        }
            cruise(fronts,distanc:frontd)
            return (speed,xcor,distance)
    }
    
    func premergeframe(_ kmerge:Bool, sides:Float, sided:Float) -> (Float,Float,Float){
        if kmerge{
            state = 2
            cruise(sides,distanc:sided)
            xcor = (Float(Double(xcor+30)/exp-30)-xcor)/10 + xcor
        }
        else{
            cruise(sides,distanc:sided)
            if distance <= 5{
                state = 2
                xcor -=  1.2
            }
            else{
                xcor = (Float(Double(xcor)/exp)-xcor)/10 + xcor
            }
        }
        return (speed,xcor,distance)
    }
    
    func calrageinframe_signs(_ signs:Array<Float>){
        if signlevel < signs.count && state < 2{
            while (distance <= signs[signlevel]){
                signlevel += 1
                rage += 10
                if signlevel >= signs.count{
                    break
                }
            }
        }
    }
    
    func ifhorn() -> Bool{
        if rage >= hornlevel*100/personality {
            rage += 5
            hornlevel += 1
            return true
        }
        else{
            return false
        }
    }
    
    func horn(){
        rage += 5
    }
    
    func bemerged(){
        rage += 30
    }
    
    func cruisedistance() -> Float{
        return 0.15*speed/(0.02*rage+1)*15+10
    }
    
    func cruise(_ spee:Float,distanc:Float){
//        let deltav = powf(speed-spee,2)/2
//        let acceptdistanc:Float = 0
//        /**/
        if distanc > 200 && speed <= maxspee{
            speed+=maxacc
            rage -= 0.01
            rage -= maxacc
        }
        else{
            if distanc > cruisedistance(){
                var temp:Float
                if speed == 0{
                    temp = (distanc - cruisedistance())/1000
                }
                else{
                    temp = ((distanc-cruisedistance())/speed)/1000
                }
                if temp > maxacc{
                    temp = maxacc
                }
                rage -= temp
                speed += temp
            }
            if distanc < cruisedistance(){
                var temp:Float
                if speed == 0{
                    temp = (distanc - cruisedistance())/10
                }
                else{
                    temp = ((distanc-cruisedistance())/speed)/10
                }
                rage -= temp
                speed += temp
                if speed <= 0 {
                    speed = 0
                    rage += 5
                }
            }
        }
        if speed >= maxspee{
            speed = maxspee
        }
    }
}
