//
//  FiveDayWeatherForecastViewController.swift
//  Clima
//
//  Created by user137691 on 6/21/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class FiveDayWeatherForecastViewController: UIViewController,ChangeCityDelegate {
    
    //MARK: - Declare Constants
    /***************************************************************/
    let Weather_URL="http://api.openweathermap.org/data/2.5/forecast"
    let appid="e72ca729af228beabd5d20e3b7749713"
   var lat=""
    var lon=""
   
    //MARK: - Declare Instances
    /***************************************************************/
    var fiveDayModel = [FiveDayWeatherModel()]
    
    //Pre-Linked IBOULET

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var dayOneTemperatureLabel: UILabel!
    @IBOutlet weak var dayTwoTemperatureLabel: UILabel!
    @IBOutlet weak var dayThreeTemperatureLabel: UILabel!
    @IBOutlet weak var dayFourTemperatureLabel: UILabel!
    @IBOutlet weak var dayFiveTemperatureLabel: UILabel!
    
     @IBOutlet weak var dayOneDateLabel: UILabel!
    @IBOutlet weak var dayTwoDateLabel: UILabel!
    @IBOutlet weak var dayThreeDateLabel: UILabel!
    @IBOutlet weak var dayFourDateLabel: UILabel!
    @IBOutlet weak var dayFiveDateLabel: UILabel!
    
    @IBOutlet weak var dayOneWeatherIcon: UIImageView!
    @IBOutlet weak var dayTwoWeatherIcon: UIImageView!
    @IBOutlet weak var dayThreeWeatherIcon: UIImageView!
    @IBOutlet weak var dayFourWeatherIcon: UIImageView!
    @IBOutlet weak var dayFiveWeatherIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData(url: Weather_URL, parameters:["lat":lat,"lon":lon,"appid":appid])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Mark: -Networking*
    func getWeatherData(url:String,parameters:[String:String])
    {
        Alamofire.request(Weather_URL,
                          method:.get,
                          parameters:parameters)
            .validate()
            .responseJSON {response in
                guard response.result.isSuccess else{
                    print("Connetion Issues")
                    return
                }
                print(JSON(response.result.value!))
                self.updateWeatherData(json:JSON(response.result.value!))
        }

    }
    //Mark: - Parsing Json
    func updateWeatherData(json:JSON)
    {
        var fiveDayModelObj=FiveDayWeatherModel()
        fiveDayModel.removeAll()
        fiveDayModelObj.temperature = Int(json["list"][0]["main"]["temp"].doubleValue-273.15)
        fiveDayModelObj.cityName = json["city"]["name"].stringValue
        fiveDayModelObj.condition=json["list"][0]["weather"][0]["id"].intValue
        fiveDayModelObj.weatherIconName=fiveDayModelObj.updateWeatherIcon(condition: fiveDayModelObj.condition)
        let index = json["list"][0]["dt_txt"].stringValue.index(of: " ")!
        fiveDayModelObj.Date = String(json["list"][0]["dt_txt"].stringValue.prefix(upTo: index))
        fiveDayModel.append(fiveDayModelObj)
        var jsonListcount:Int=1
        for _ in json["list"]{
            fiveDayModelObj=FiveDayWeatherModel()
            fiveDayModelObj.Date=String(json["list"][jsonListcount]["dt_txt"].stringValue.prefix(upTo: index))
            guard (fiveDayModelObj.Date != fiveDayModel[fiveDayModel.count-1].Date)else{
                jsonListcount+=1
                continue  
            }
            fiveDayModelObj.temperature = Int(json["list"][jsonListcount]["main"]["temp"].doubleValue-273.15)
            fiveDayModelObj.cityName = json["city"]["name"].stringValue
            fiveDayModelObj.condition=json["list"][jsonListcount]["weather"][0]["id"].intValue
            fiveDayModelObj.weatherIconName=fiveDayModelObj.updateWeatherIcon(condition: fiveDayModelObj.condition)
            fiveDayModel.append(fiveDayModelObj)
        }
        for wx in fiveDayModel{
            wx.description() // added a description method to WeatherDataModel just to show data
        }
        UpdateUI()
    }
    
    // Mark: -Update UI
    //***************************************************
    func  UpdateUI() {
        dayOneDateLabel.text=fiveDayModel[0].Date
        dayOneTemperatureLabel.text=String(fiveDayModel[0].temperature)
        dayOneWeatherIcon.image=UIImage(named: fiveDayModel[0].weatherIconName)
        
        dayTwoDateLabel.text=fiveDayModel[1].Date
        dayTwoTemperatureLabel.text=String(fiveDayModel[1].temperature)
        dayTwoWeatherIcon.image=UIImage(named: fiveDayModel[1].weatherIconName)
        
        dayThreeDateLabel.text=fiveDayModel[2].Date
        dayThreeTemperatureLabel.text=String(fiveDayModel[2].temperature)
        dayThreeWeatherIcon.image=UIImage(named: fiveDayModel[2].weatherIconName)
        
        
        dayFourDateLabel.text=fiveDayModel[3].Date
        dayFourTemperatureLabel.text=String(fiveDayModel[3].temperature)
        dayFourWeatherIcon.image=UIImage(named: fiveDayModel[3].weatherIconName)
        
        dayFiveDateLabel.text=fiveDayModel[4].Date
        dayFiveTemperatureLabel.text=String(fiveDayModel[4].temperature)
        dayFiveWeatherIcon.image=UIImage(named: fiveDayModel[4].weatherIconName)
        
        cityNameLabel.text=fiveDayModel[0].cityName
    }
    func UserEnteredNewCityName(city: String) {
              getWeatherData(url: Weather_URL, parameters:["q":city,"appid":appid])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="FiveDayWeatherByCity"){
            let destinationVC=segue.destination as! ChangeCityViewController
            destinationVC.delegate=self
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
