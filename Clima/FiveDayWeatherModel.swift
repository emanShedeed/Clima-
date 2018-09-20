//
//  FiveDayWeatherModel.swift
//  Clima
//
//  Created by user137691 on 6/25/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
class FiveDayWeatherModel:WeatherDataModel{

 var Date:String=""
    
    func description() {
        print(self.cityName,", Temp - ",self.temperature,", Date ",self.Date,", Cond ",self.condition, ", Icon Name: ", self.weatherIconName)
    }

}
