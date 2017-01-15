//
//  LeftCar.swift
//  ModellingLaneMerging
//
//  Created by Dun Ma on 15/11/13.
//  Copyright (c) 2015年 Dun Ma. All rights reserved.
//

import Foundation

class LeftCar {
    
    init(spee:Float, ind:Int, dis:Float, person:Float,maxs:Float){
        speed = spee
        distance = dis
        index=ind
        leftlineindex = ind/2
        personality = person
        maxspee = maxs
    }
    
    var speed:Float
    var distance:Float
    let exp = 2.718
    var index:Int
    var maxspee:Float = 1.6
    let maxacc:Float = 0.1
    var state:Float = 0
    var leftlineindex:Int = 0
    var rage:Float = 0
    var hornlevel:Float = 1
    var signlevel:Int = 0
    var personality: Float = 0
    var wait:Int = 0
    
    func frame(_ frontd:Float, fronts:Float, forntmerging:Bool) -> Float{
        if rage <= 0 || distance >= 200
        {
            rage = 0
        }
        cruise(fronts, distanc: frontd,frontmerging: forntmerging)
      //  speed = Float(Double(speed-fronts)/exp)+fronts
        return distance
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
    
    func cruisedistance(_ frontmerging:Bool) -> Float{
        if frontmerging{return 0.15*speed/(0.02*rage+1)*15+10}
        else{return 0.15*speed/(0.02*rage+1)*15+10}
    }
    
    func cruise(_ spee:Float,distanc:Float, frontmerging:Bool){
        //        let deltav = powf(speed-spee,2)/2
        //        let acceptdistanc:Float = 0
        //        /**/
        let cerrr = cruisedistance(frontmerging)
        if distanc > 50 && speed <= maxspee{
            speed+=maxacc
            rage -= 0.1
            rage -= maxacc
        }
        else{
            if distanc > cerrr{
                var temp:Float
                if speed == 0{
                    temp = (distanc - cerrr)/1000
                }
                else{
                    temp = (distanc - cerrr)/speed/1000
                }
                if temp > maxacc{
                    temp = maxacc
                }
                rage -= temp
                speed += temp
            }
            if distanc < cerrr{
                var temp:Float
                if speed == 0{
                    temp = (distanc-cerrr)/10
                }
                else{
                    temp = (distanc-cerrr)/speed/10
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
