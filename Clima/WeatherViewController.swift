//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController,CLLocationManagerDelegate,ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    var location:CLLocation?
    
    //TODO: Declare instance variables here
    let locationManager=CLLocationManager()
    let weatherDataModel=WeatherDataModel()
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
      
      
        //switchTemperature.addTarget(self, action: #selector(stateChanged(_:)), for: .valueChanged)
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String,param:[String:String])
    {
   /*     Alamofire.request(url, method: .get,parameters: param).responseJSON{
            response in
            if(response.result.isSuccess)
            {
                //print("response = \(JSON( response.result.value!))")
                self.updateWeatherData(json: JSON( response.result.value!))
                
            }
            else
            {
                self.cityLabel.text="Cann't get weather data"
            }
        
        
        }*/

        Alamofire.request(url,
                          method: .get,
                          parameters:param)
             .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    self.cityLabel.text="Cann't get weather data"
                    return
                }
                 self.updateWeatherData(json: JSON( response.result.value!))
                
        }
    }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
   func updateWeatherData(json:JSON)
   {
    weatherDataModel.temperature=Int(json["main"]["temp"].double!-273.15)
    weatherDataModel.cityName=json["name"].stringValue
    weatherDataModel.condition=json["weather"]["0"]["id"].intValue
    weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    
    updateUIWithWeatherData()
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData()
    {
        cityLabel.text=weatherDataModel.cityName;
        temperatureLabel.text=String( weatherDataModel.temperature)
        weatherIcon.image=UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         location = locations[locations.count-1]
        
        if let l=location
        {
            if(l.horizontalAccuracy>0)
            {
            locationManager.stopUpdatingLocation()
            locationManager.delegate=nil
            print("latitude=\(l.coordinate.latitude) , Langtitude= \(l.coordinate.longitude)")
            let parmameters:[String:String]=["lat":String(l.coordinate.latitude),"lon":String(l.coordinate.longitude),"appid":APP_ID]
            getWeatherData(url:WEATHER_URL , param:parmameters)
        }
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error : \(error)")
        cityLabel.text="connection Issues"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func UserEnteredNewCityName(city: String) {
        print(city)
        let param=["q":city,"appid":APP_ID]
        getWeatherData(url: WEATHER_URL, param: param)
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="changeCityName")
        {
        let destinationVC=segue.destination as! ChangeCityViewController
            destinationVC.delegate=self
        }
        if(segue.identifier=="FiveDayWeather"){
            let destinationVC=segue.destination as!FiveDayWeatherForecastViewController
            destinationVC.lat=String(Double(location!.coordinate.latitude))
            destinationVC.lon=String(Double(location!.coordinate.longitude))
        }
    }
    //Mark:Add Target
    
   /* @objc func stateChanged(_ sender:UISwitch)  {
        if(sender.isOn){
            temperatureLabel.text=String((Double(temperatureLabel.text!)!-32)*5/9)
            
        }
        else{
            temperatureLabel.text=String((Double(temperatureLabel.text!)!*9/5)+32)
        }
    }*/
    
    @IBAction func switchTemperature(_ sender: UISwitch) {
        if(sender.isOn)
        {
             temperatureLabel.text=String(weatherDataModel.temperature)
            
        }
        else{
            temperatureLabel.text=String((Double(weatherDataModel.temperature )*9/5)+32)
            
        }
    }
}
    
    



