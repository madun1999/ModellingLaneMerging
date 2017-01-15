//
//  ViewController.swift
//  ModellingLaneMerging
//
//  Created by Dun Ma on 15/11/12.
//  Copyright (c) 2015年 Dun Ma. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        signs = [100,50,20]
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    /* importing images */
    @IBAction func starttimer(_ sender: AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.frame), userInfo: nil, repeats: true)
    }
    var imagesarray:Array<NSImageView> = []
    let image1 = NSImage(byReferencingFile: Bundle.main.pathForImageResource("images1.png")!)!
    let image2 = NSImage(byReferencingFile: Bundle.main.pathForImageResource("images2.png")!)!


    @IBOutlet weak var firstsign: NSTextField!
    @IBOutlet weak var secondsign: NSTextField!
    @IBOutlet weak var thirdsign: NSTextField!
    /* number of cars*/
    var number = 100

    /*right&left cars(class)*/
    var RightCars: Array<RightCar> = []
    var LeftCars: Array<LeftCar> = []
    
    /*wall*/
    let wall: LeftCar = LeftCar(spee: 0, ind: 0, dis: 5 , person:1,maxs:0)
    
    /*right&left lane +merging index*/
    /*LeftCar odd, Rightcar even*/
    var rightlane: Array<Int> = []
    var leftlane: Array<Int> = []
    
    /*No. of passed cars*/
    var stopNo:Int = 0
    var time:Int = 0
    
    /*signs*/
    var signs:Array<Float> = []
    
    var rank:Array<Int> = []
    var velo:Array<Float> = []
    var rage:Array<Float> = []
    
    /*lengnth*/
    let length:Float = 200
    var tim:Int = 0

    /*UI*/
    @IBOutlet weak var timeLabel: NSTextField!
    @IBAction func runonce(_ sender: AnyObject) {

        RightCars.removeAll(keepingCapacity: false)
        LeftCars.removeAll(keepingCapacity: false)
        rightlane.removeAll(keepingCapacity: false)
        leftlane.removeAll(keepingCapacity: false)
        stopNo = 0
        time = 0
        tim = 0
        signs[0] = Float(Int(firstsign.stringValue) ?? 100)
        signs[1] = Float(Int(secondsign.stringValue) ?? 50)
        signs[2] = Float(Int(thirdsign.stringValue) ?? 20)
        let perso:Array<Float> = [0.8,1,1.2]
        let probs:Array<Float> = [0.1,0.9,1.0]
        number = 100
        var a: Array<Int> = []
        for k in 0..<number{
            a.append(Int(arc4random_uniform(100)))
        }
        for k in 0..<number{
            var dis:Float = 0
            var pers:Float = 0
            switch a[k]{
            case  0..<Int(probs[0]*100): dis = signs[0] ; pers = perso[0]
            case Int(probs[0]*100)..<Int(probs[1]*100): dis = signs[1];pers = perso[1]
            case Int(probs[1]*100)...Int(probs[2]*100): dis = signs[2];pers = perso[2]
            default: dis = signs[0] ; pers = perso[2]
            }
            LeftCars.append(LeftCar(spee: 0, ind:2*k+1, dis: (length + Float(7 * k)) ,person:pers,maxs:1.3))
            RightCars.append(RightCar(spee: 0, mergedis: dis, ind: 2*(k+1),dis:(length + Float(7 * k)),person:pers , maxs:1.3))
            leftlane.append(2*k+1)
            rightlane.append(2*k+2)
        }
        rank = Array<Int>(repeating: 0, count: number*2)
        velo = Array<Float>(repeating: 0, count: number*2)
        rage = Array<Float>(repeating: 0, count: number*2)
        
        
        
        while stopNo != number * 2{
            frame()
            tim += 1
        }
        let text1 = NSTextField(frame: NSRect(x: 70, y: 100, width: 80, height: 20))
        text1.stringValue = "good,\(tim)"
        self.view.addSubview(text1)
    }
    
    /*one frame*/
    func frame(){
        /*Remove previous cars*/
        for a in view.subviews{
            if a is NSImageView{
//                if  a.image!() != image3
//                {
                    a.removeFromSuperview()
//                }
            }
//            if  a is NSTextField
//            {
//                let b:NSTextField = a as! NSTextField
//                if b.frame.width != 1000
//                {
//                    b.removeFromSuperview()
//                }
//            }
        }
        for m in 0..<number{
            RightCars[m].distance -= RightCars[m].speed
            LeftCars[m].distance -= LeftCars[m].speed
        }
        /*update from the front*/
        for i in 0..<number{
            /*incoming transition vars*/
            var dista:Float = 0
            var xcor:Float = 0
            var speea:Float = 0
            /*output transition vars*/
            var frontd:Float = 0
            var fronts:Float = 0
        /*firstlyright cars*/
            if RightCars[i].state < 4 {
                /*stop cars*/
                if RightCars[i].distance <= 0{
                    if RightCars[i].state < 3{
                        if RightCars[i].rightlaneindex+1 < rightlane.count{
                            for t in rightlane[RightCars[i].rightlaneindex+1..<rightlane.count]{
                                RightCars[t/2-1].rightlaneindex -= 1
                            }
                        }
                        rightlane.remove(at: RightCars[i].rightlaneindex)
                    }
                    stopNo += 1
                    velo[RightCars[i].index-1] = RightCars[i].speed
                    rank[RightCars[i].index-1] = stopNo
                    rage[RightCars[i].index-1] = RightCars[i].rage
                    RightCars[i].state = 1
                    RightCars[i].distance = -200
                    RightCars[i].speed = 0
                    RightCars[i].state = 4
                    
                    if stopNo == number * 2{
                        var output:String = ""
                        var norms:String = ""
                        var velos:String = ""
                        var ranks:String = ""
                        var rages:String = ""
                        for last in 0..<number*2{
                            norms = norms + "\(last+1),"
                            velos = velos + "\(velo[last]),"
                            ranks = ranks + "\(rank[last]),"
                            rages = rages + "\(rage[last]),"
                        }
                        rages.remove(at: rages.characters.index(before: rages.endIndex))
                        velos.remove(at: velos.characters.index(before: velos.endIndex))
                        ranks.remove(at: ranks.characters.index(before: ranks.endIndex))
                        norms.remove(at: norms.characters.index(before: norms.endIndex))
                        velos += "; "
                        ranks += "; "
                        norms += "; "
                        output = "(["+norms + ranks + velos + rages + "])"
                        let text1 = NSTextField(frame: NSRect(x: Double(4)*10, y: 50, width: 1000, height: 40))
                        text1.stringValue = output

                        self.view.addSubview(text1)
                        
                    }
                    
                    if RightCars[i].leftlaneindex+1 < leftlane.count{
                        for t in leftlane[RightCars[i].leftlaneindex+1..<leftlane.count]{
                            if t % 2 == 0{
                                RightCars[t/2-1].leftlaneindex -= 1
                            }
                            else{
                                LeftCars[t/2].leftlineindex -= 1
                            }
                        }
                    }
                    leftlane.remove(at: RightCars[i].leftlaneindex)
                }
                else {
                    /*analysing positional car*/
                    /*state 0*/
                    if RightCars[i].state == 0{
                            let temp = RightCars[i].rightlaneindex
                            if temp != 0{
                                frontd = RightCars[i].distance - RightCars[rightlane[temp-1]/2-1].distance
                                fronts = RightCars[rightlane[temp-1]/2-1].speed
                            }
                            else{
                                frontd = RightCars[i].distance
                                fronts = 0
                            }
                        }
                    /*state 1&2*/
                    if RightCars[i].state == 1 || RightCars[i].state == 2{
                            let templeft = RightCars[i].leftlaneindex
                            let tempright = RightCars[i].rightlaneindex
                            if templeft != 0{
                                /*not the first on the left*/
                                if tempright != 0{
                                    /*not the first on the right*/
                                    if leftlane[templeft-1] % 2 == 0{
                                        let a = RightCars[leftlane[templeft-1]/2-1]
                                        let b = RightCars[rightlane[tempright-1]/2-1]
                                        if a.distance >= b.distance{
                                            fronts = a.speed
                                            frontd = RightCars[i].distance - a.distance
                                        }
                                        else{
                                            fronts = b.speed
                                            frontd = RightCars[i].distance - b.distance
                                        }
                                    }
                                    else{
                                        let a = RightCars[rightlane[tempright-1]/2-1]
                                        let b = LeftCars[leftlane[templeft-1]/2]
                                        if a.distance >= b.distance{
                                            fronts = a.speed
                                            frontd = RightCars[i].distance - a.distance
                                        }
                                        else{
                                            fronts = b.speed
                                            frontd = RightCars[i].distance - b.distance
                                        }
                                    }
                                }
                                else{
                                    /* the first on the right*/
                                    if leftlane[templeft-1] % 2 == 0{
                                        let a = RightCars[leftlane[templeft-1]/2-1]
                                        let b = wall
                                        if a.distance >= b.distance{
                                            fronts = a.speed
                                            frontd = RightCars[i].distance - a.distance
                                        }
                                        else{
                                            fronts = b.speed
                                            frontd = RightCars[i].distance - b.distance
                                        }
                                    }
                                    else{
                                        let a = LeftCars[leftlane[templeft-1]/2]
                                        let b = wall
                                        if a.distance >= b.distance{
                                            fronts = a.speed
                                            frontd = RightCars[i].distance - a.distance
                                        }
                                        else{
                                            fronts = b.speed
                                            frontd = RightCars[i].distance - b.distance
                                        }
                                    }
                                }
                            }
                            else{
                                if tempright != 0{
                                    let a = RightCars[rightlane[tempright-1]/2-1]
                                    fronts = a.speed
                                    frontd = RightCars[i].distance - a.distance
                                }
                                else{
                                    /* the first on the right*/
                                    fronts = 1
                                    frontd = RightCars[i].distance
                                    if frontd <= 5{
                                        frontd = 0
                                    }
                                }
                            }
                        }
                    /*state 3*/
                    if RightCars[i].state == 3{
                            let temp = RightCars[i].leftlaneindex
                            if temp != 0{
                                if leftlane[temp-1] % 2 == 0{
                                    let a = RightCars[leftlane[temp-1]/2-1]
                                        fronts = a.speed
                                        frontd = RightCars[i].distance - a.distance
                                }
                                else{
                                    let a = LeftCars[leftlane[temp-1]/2]
                                    
                                        fronts = a.speed
                                        frontd = RightCars[i].distance - a.distance
                                }
                            }
                            else{
                                frontd = RightCars[i].distance + 200
                                fronts = 200
                            }
                        }
                    (speea,xcor,dista) = RightCars[i].frame(frontd, fronts: fronts)
                    if RightCars[i].distance <= 0{
                            if RightCars[i].state != 3{
                                if RightCars[i].rightlaneindex+1 < rightlane.count{
                                    for t in rightlane[RightCars[i].rightlaneindex+1..<rightlane.count]{
                                        RightCars[t/2-1].rightlaneindex -= 1
                                    }
                                }
                                rightlane.remove(at: RightCars[i].rightlaneindex)
                            }
                            stopNo += 1
                            velo[RightCars[i].index-1] = RightCars[i].speed
                            rank[RightCars[i].index-1] = stopNo
                            rage[RightCars[i].index-1] = RightCars[i].rage
                            RightCars[i].state = 1
                            RightCars[i].distance = -200
                            RightCars[i].speed = 0
                            RightCars[i].state = 4
                            if stopNo == number * 2{
                                var output:String = ""
                                var norms:String = ""
                                var velos:String = ""
                                var ranks:String = ""
                                var rages:String = ""
                                for last in 0..<number*2{
                                    norms = norms + "\(last+1),"
                                    velos = velos + "\(velo[last]),"
                                    ranks = ranks + "\(rank[last])"
                                    rages = rages + "\(rage[last]),"
                                }
                                rages.remove(at: rages.characters.index(before: rages.endIndex))
                                velos.remove(at: velos.characters.index(before: velos.endIndex))
                                ranks.remove(at: ranks.characters.index(before: ranks.endIndex))
                                norms.remove(at: norms.characters.index(before: norms.endIndex))
                                velos += "; "
                                ranks += "; "
                                norms += "; "
                                output = "{[" + norms + ranks + velos + rages + "]}"
                                let text1 = NSTextField(frame: NSRect(x: Double(4)*10, y: 50, width: 1000, height: 40))
                                text1.stringValue = output
                                self.view.addSubview(text1)
                            }
                            if RightCars[i].leftlaneindex+1 < leftlane.count{
                                for t in leftlane[RightCars[i].leftlaneindex+1..<leftlane.count]{
                                    if t % 2 == 0{
                                        RightCars[t/2-1].leftlaneindex -= 1
                                    }
                                    else{
                                        LeftCars[t/2].leftlineindex -= 1
                                    }
                                }
                            }
                            leftlane.remove(at: RightCars[i].leftlaneindex)
                        }
                    if xcor == 401{
                        var mindis:Float = 10000
                        var clindex:Int = 0
                        for t in leftlane{
                            if t % 2 == 0{
                                let temp = RightCars[t/2-1].distance
                                if temp < dista+1.5 && dista+1.5-temp <= mindis{
                                    mindis = dista+1.5-temp
                                    clindex = RightCars[t/2-1].leftlaneindex
                                }
                            }
                            else{
                                let temp = LeftCars[t/2].distance
                                if temp < dista+1.5 && dista+1.5-temp <= mindis{
                                    mindis = dista+1.5-temp
                                    clindex = LeftCars[t/2].leftlineindex
                                }
                            }
                        }
                        RightCars[i].leftlaneindex = clindex + 1
                        leftlane.insert(RightCars[i].index, at: clindex+1)
                        if clindex+2<leftlane.count{
                            for t in leftlane[clindex+2..<leftlane.count]{
                                if t % 2 == 0{
                                    RightCars[t/2-1].leftlaneindex += 1
                                }
                                else{
                                    LeftCars[t/2].leftlineindex += 1
                                }
                            }
                        }
                        let tempp = leftlane[clindex]
                        if tempp % 2 == 0{
                            frontd = RightCars[i].distance - RightCars[tempp/2-1].distance
                            fronts = RightCars[tempp/2-1].speed
                        }
                        else{
                            frontd = RightCars[i].distance - LeftCars[tempp/2].distance
                            fronts = LeftCars[tempp/2].speed
                        }
                        (speea,xcor,dista)=RightCars[i].frame(fronts, fronts: frontd)
                    }
                    if xcor == 402{
                        let tempr = RightCars[i].leftlaneindex
                        let tempdis = RightCars[i].distance
                        var flag:Bool = false
                        var flag2:Bool = false
                        var frontdis:Float = 0
                        var backdis:Float = 0
                        let t:Float = 3
                        if tempr != 0{
                            if tempr >= leftlane.count - 1{
                                flag = true
                                frontdis = 7
                                if leftlane[tempr-1] % 2 == 0{
                                    flag2 = RightCars[leftlane[tempr-1]/2-1].distance-tempdis <= -t
                                }
                                else{
                                    flag2 = LeftCars[leftlane[tempr-1]/2].distance-tempdis <= -t
                                }
                            }
                            else{
                                
                                if leftlane[tempr-1] % 2 == 0{
                                    flag2 = RightCars[leftlane[tempr-1]/2-1].distance-tempdis <= -t
                                    frontdis = RightCars[leftlane[tempr-1]/2-1].distance
                                }
                                else{
                                    flag2 = LeftCars[leftlane[tempr-1]/2].distance-tempdis <= -t
                                    frontdis = LeftCars[leftlane[tempr-1]/2].distance
                                }
                                
                                if leftlane[tempr+1] % 2 == 0{
                                    flag2 = RightCars[leftlane[tempr+1]/2-1].distance-tempdis >= t && flag2
                                    frontdis = RightCars[leftlane[tempr+1]/2-1].distance - frontdis
                                }
                                else{
                                    flag2 = LeftCars[leftlane[tempr+1]/2].distance-tempdis >= t && flag2
                                    frontdis = LeftCars[leftlane[tempr+1]/2].distance - frontdis
                                }
                            }
                            let tempp = leftlane[tempr-1]
                            if tempp % 2 == 0{
                                frontd = RightCars[i].distance - RightCars[tempp/2-1].distance
                                fronts = RightCars[tempp/2-1].speed
                            }
                            else{
                                frontd = RightCars[i].distance - LeftCars[tempp/2].distance
                                fronts = LeftCars[tempp/2].speed
                            }
                        }
                        else{
                            if tempr >= leftlane.count - 1{
                                flag = true
                                frontdis = 7
                                flag2 = true
                            }
                            else{
                                if leftlane[tempr+1] % 2 == 0{
                                    flag2 = RightCars[leftlane[tempr+1]/2-1].distance-tempdis >= t
                                    fronts = 0
                                    frontd = 20
                                }
                                else{
                                    flag2 = LeftCars[leftlane[tempr+1]/2].distance-tempdis >= t
                                    fronts = 0
                                    frontd = 20
                                }
                            }
                        }
                        flag = frontdis >= 4
                        (speea,xcor,dista)=RightCars[i].premergeframe(flag&&flag2, sides: fronts, sided: frontd)
                    }
                        /* leaving rightlane*/
                    if xcor == 101{
                        let c = RightCars[i].rightlaneindex
                        if c+1 < rightlane.count{
                            for t in rightlane[c+1..<rightlane.count]{
                                RightCars[t/2-1].rightlaneindex -= 1
                            }
                        }
                        if RightCars[i].leftlaneindex < leftlane.count - 1{
                            let tem = leftlane[RightCars[i].leftlaneindex + 1]
                            if tem % 2 == 0{
                                RightCars[tem/2-1].bemerged()
                            }
                            else{
                                LeftCars[tem/2].bemerged()
                            }
                        }
                        rightlane.remove(at: c)
                    }
                    RightCars[i].calrageinframe_signs(signs)
                    if RightCars[i].ifhorn() {
                        let imageView7 = NSImageView(frame: NSRect(x: Double(220-dista)*10 , y: Double(50-xcor), width: 30, height: 20))
                            imageView7.image = image2
                            imageView7.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
                        self.view.addSubview(imageView7)
                        if RightCars[i].state <= 2{
                            if RightCars[i].rightlaneindex < rightlane.count - 1{
                                RightCars[rightlane[RightCars[i].rightlaneindex + 1]/2-1].horn()
                            }
                            if RightCars[i].rightlaneindex != 0{
                                RightCars[rightlane[RightCars[i].rightlaneindex-1]/2-1].horn()
                            }
                        }
                        if RightCars[i].state >= 1 {
                            if RightCars[i].leftlaneindex < leftlane.count - 1
                            {
                                let temc = leftlane[RightCars[i].leftlaneindex + 1]
                                if temc % 2 == 0{RightCars[temc/2-1].horn()}
                                else{LeftCars[temc/2].horn()}
                            }
                            if RightCars[i].leftlaneindex != 0{
                            let temd = leftlane[RightCars[i].leftlaneindex - 1]
                                if temd % 2 == 0{RightCars[temd/2-1].horn()}
                                else{LeftCars[temd/2].horn()}
                            }
                        }
                    }
                }
                /*rendering right car*/
//                let text1 = NSTextField(frame: NSRect(x: Double(220-dista)*10, y: Double(30-xcor), width: 30, height: 20))
//                text1.stringValue = "\(RightCars[i].rightlaneindex)"
//                self.view.addSubview(text1)
                let imageView3 = NSImageView(frame: NSRect(x: Double(220-dista)*10 , y: Double(50-xcor), width: 30, height: 20))
                if i == 0 {imageView3.image = image1} else {imageView3.image = image2}
                self.view.addSubview(imageView3)
            }
        /*secondly left cars*/
            if LeftCars[i].state != 1 {var tempe=LeftCars[i].leftlineindex
                var flad = false
            if tempe != 0{
                if leftlane[tempe-1] % 2 == 0{
                    let a = RightCars[leftlane[tempe-1]/2-1]
                    fronts = a.speed
                    frontd = LeftCars[i].distance - a.distance
                    if a.state == 1{
                        flad = true
                    }
                }
                else{
                    if LeftCars[i].distance <= 0{
                        stopNo += 1
                        velo[LeftCars[i].index-1] = LeftCars[i].speed
                        rank[LeftCars[i].index-1] = stopNo
                        rage[LeftCars[i].index-1] = LeftCars[i].rage
                        LeftCars[i].state = 1
                        LeftCars[i].distance = -200
                        LeftCars[i].speed = 0
                        if stopNo == number * 2{
                            var output:String = ""
                            var norms:String = ""
                            var velos:String = ""
                            var ranks:String = ""
                            var rages:String = ""
                            for last in 0..<number*2{
                                norms = norms + "\(last+1),"
                                velos = velos + "\(velo[last]),"
                                ranks = ranks + "\(rank[last]),"
                                rages = rages + "\(rage[last]),"
                            }
                            rages.remove(at: rages.characters.index(before: rages.endIndex))
                            velos.remove(at: velos.characters.index(before: velos.endIndex))
                            ranks.remove(at: ranks.characters.index(before: ranks.endIndex))
                            norms.remove(at: norms.characters.index(before: norms.endIndex))
                            velos += "; "
                            ranks += "; "
                            norms += "; "
                            output = "(["+norms + ranks + velos + rages + "])"
                            let text1 = NSTextField(frame: NSRect(x: Double(4)*10, y: 50, width: 1000, height: 40))
                            text1.stringValue = output
                            self.view.addSubview(text1)
                        }
                        if LeftCars[i].leftlineindex+1 < leftlane.count{
                            for t in leftlane[LeftCars[i].leftlineindex+1..<leftlane.count]{
                                if t % 2 == 0{RightCars[t/2-1].leftlaneindex -= 1}
                                else{LeftCars[t/2].leftlineindex -= 1}
                            }
                        }
                        leftlane.remove(at: 0)
                    }
                    else {
                        if leftlane[tempe-1] % 2 == 0{
                            let a = RightCars[leftlane[tempe-1]/2-1]
                        
                            fronts = a.speed
                            frontd = LeftCars[i].distance - a.distance
                            if a.state == 1{
                                flad = true
                            }
                        }
                        else{
                            let a = LeftCars[leftlane[tempe-1]/2]
                            fronts = a.speed
                            frontd = LeftCars[i].distance - a.distance
                        }
                    }
                }
            }
            else{
                if LeftCars[i].distance <= 0{
                    stopNo += 1
                    velo[LeftCars[i].index-1] = LeftCars[i].speed
                    rank[LeftCars[i].index-1] = stopNo
                    rage[LeftCars[i].index-1] = LeftCars[i].rage
                    LeftCars[i].state = 1
                    LeftCars[i].distance = -200
                    LeftCars[i].speed = 0
                    LeftCars[i].state = 1
                    if stopNo == number * 2{
                        var output:String = ""
                        var norms:String = ""
                        var velos:String = ""
                        var ranks:String = ""
                        var rages:String = ""
                        for last in 0..<number*2{
                            norms = norms + "\(last+1),"
                            velos = velos + "\(velo[last]),"
                            ranks = ranks + "\(rank[last]),"
                            rages = rages + "\(rage[last]),"
                        }
                        rages.remove(at: rages.characters.index(before: rages.endIndex))
                        velos.remove(at: velos.characters.index(before: velos.endIndex))
                        ranks.remove(at: ranks.characters.index(before: ranks.endIndex))
                        norms.remove(at: norms.characters.index(before: norms.endIndex))
                        velos += "; "
                        ranks += "; "
                        norms += "; "
                        output = "(["+norms + ranks + velos + rages + "])"
                        let text1 = NSTextField(frame: NSRect(x: Double(4)*10, y: 50, width: 1000, height: 40))
                        text1.stringValue = output
                        self.view.addSubview(text1)
                    }
                    if LeftCars[i].leftlineindex+1 < leftlane.count{
                        for t in leftlane[LeftCars[i].leftlineindex+1..<leftlane.count]{
                            if t % 2 == 0{
                                RightCars[t/2-1].leftlaneindex -= 1
                            }
                            else{
                                LeftCars[t/2].leftlineindex -= 1
                            }
                        }
                    }
                    leftlane.remove(at: 0)
                }
                else{
                    frontd = 200
                    fronts = 0
                }
                
            }
                if LeftCars[i].ifhorn() {
                    let imageView7 = NSImageView(frame: NSRect(x: Double(220-dista)*10 , y: Double(80), width: 30, height: 20))
                    imageView7.image = image2
                    imageView7.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
                    self.view.addSubview(imageView7)
                        if LeftCars[i].leftlineindex < leftlane.count - 1{
                            let temc = leftlane[LeftCars[i].leftlineindex + 1]
                            if temc % 2 == 0{
                                RightCars[temc/2-1].horn()
                            }
                            else{
                                LeftCars[temc/2].horn()
                            }
                        }
                        if LeftCars[i].leftlineindex != 0{
                            let temd = leftlane[LeftCars[i].leftlineindex - 1]
                            if temd % 2 == 0{
                                RightCars[temd/2-1].horn()
                            }
                            else{
                                LeftCars[temd/2].horn()
                            }
                        }
                }
                dista = LeftCars[i].frame(frontd, fronts: fronts,forntmerging:flad)
                /*rendering leftcars*/
//            let text2 = NSTextField(frame: NSRect(x: Double(220-dista)*10, y: Double(90), width: 30, height: 20))
//                text2.stringValue = "\(LeftCars[i].rage)"
//            self.view.addSubview(text2)
                let imageView2 = NSImageView(frame: NSRect(x:Double(220-dista)*10 , y: Double(80), width: 30, height: 20))
            if i==0 {imageView2.image = image1} else {imageView2.image = image2}
            self.view.addSubview(imageView2)
            }
        }
        time += 1
        timeLabel.stringValue = "\(time)"
    }
    @IBAction func stopped(_ sender: AnyObject) {
        if stopNo == number * 2{
            var output:String = ""
            var norms:String = ""
            var velos:String = ""
            var ranks:String = ""
            var rages:String = ""
            for last in 0..<number*2{
                norms = norms + "\(last+1),"
                velos = velos + "\(velo[last]),"
                ranks = ranks + "\(rank[last]),"
                rages = rages + "\(rage[last]),"
            }
            rages.remove(at: rages.characters.index(before: rages.endIndex))
            velos.remove(at: velos.characters.index(before: velos.endIndex))
            ranks.remove(at: ranks.characters.index(before: ranks.endIndex))
            norms.remove(at: norms.characters.index(before: norms.endIndex))
            velos += "; "
            ranks += "; "
            norms += "; "
            output = "(["+norms + ranks + velos + rages + "])"
            let text1 = NSTextField(frame: NSRect(x: Double(4)*10, y: 50, width: 1000, height: 40))
            text1.stringValue = output
            self.view.addSubview(text1)
        }
    }
}
