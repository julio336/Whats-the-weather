//
//  ViewController.swift
//  whats the weather
//
//  Created by Julio Ahuactzin on 31/08/15.
//  Copyright (c) 2015 Julio Ahuactzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var userCity: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text + "/forecasts/latest")
        println("\(url)")
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) -> Void in
                var urlError = false
                var weather = ""
                
                if error == nil {
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    //                    println(urlContent)
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlContentArray.count > 0 {
                        
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        weather = weatherArray[0] as! String
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                        
                    } else {
                        urlError = true
                    }
                    
                } else {
                    
                    urlError = true
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if urlError == true {
                        self.showError()
                        
                    } else {
                        
                        self.resultLabel.text = weather
                    }
                }
                
                
                
            })
            
            task.resume()
            
        } else {
            
            showError()
            
        }
        
    }
    
    func showError (){
        
        resultLabel.text = "Not able to find weather for " + userCity.text + " please try again!"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        
        userCity.resignFirstResponder()
        return true
    }


}

