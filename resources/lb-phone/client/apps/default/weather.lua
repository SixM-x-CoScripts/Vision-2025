local weathers = {
    [`BLIZZARD`] = {
        background = "snow",
        icon = "snow",
        temperature = {-15, 10},
    },
    [`CLEAR`] = {
        background = "sunny",
        icon = "sunny",
        temperature = {80, 95},
    },
    [`CLEARING`] = {
        background = "rain",
        icon = "cloudy",
        temperature = {75, 85},
    },
    [`CLOUDS`] = {
        background = "cloudy",
        icon = "cloudy",
        temperature = {80, 90},
    },
    [`EXTRASUNNY`] = {
        background = "sunny",
        icon = "sunny",
        temperature = {90, 110},
    },
    [`FOGGY`] = {
        background = "cloudy",
        icon = "fog",
        temperature = {80, 90},
    },
    [`HALLOWEEN`] = {
        background = "night",
        icon = "tornado",
        temperature = {50, 60},
    },
    [`NEUTRAL`] = {
        background = "cloudy",
        icon = "partly-cloudy",
        temperature = {80, 95},
    },
    [`OVERCAST`] = {
        background = "cloudy",
        icon = "partly-cloudy",
        temperature = {80, 85},
    },
    [`RAIN`] = {
        background = "rain",
        icon = "cloudy", -- if it's raining, it will automatically set icon to rain
        temperature = {75, 90},
    },
    [`SMOG`] = {
        background = "cloudy",
        icon = "fog",
        temperature = {90, 95},
    },
    [`SNOW`] = {
        background = "snow",
        icon = "snow",
        temperature = {0, 32},
    },
    [`SNOWLIGHT`] = {
        background = "snow",
        icon = "snow",
        temperature = {0, 32},
    },
    [`THUNDER`] = {
        background = "rain", --CAHNGE THIS LATER
        icon = "thunder",
        temperature = {75, 90},
    },
    [`XMAS`] = {
        background = "snow",
        icon = "snow",
        temperature = {-5, 15},
    },
}

RegisterNUICallback("Weather", function(data, cb)
    local action = data.action

    if action == "getData" then
        local currentWeather, nextWeather, nextWeatherPercent = GetWeatherTypeTransition()
        local rainLevel = GetRainLevel()
        local windSpeed = GetWindSpeed()
        local windDirection = GetWindDirection()
        local weatherData = table.deep_clone(weathers[currentWeather])
        local hour = GetClockHours()

        if rainLevel > 0.6 then
            weatherData.icon = "heavy-rain"
        elseif rainLevel > 0.3 then
            weatherData.icon = "rain"
        elseif rainLevel > 0.0 then
            weatherData.icon = "drizzle"
        end

        if weatherData.icon == "partly-cloudy" then
            if hour >= 21 or hour <= 5 then
                weatherData.icon = weatherData.icon .. "-night"
            else
                weatherData.icon = weatherData.icon .. "-sunny"
            end
        elseif weatherData.icon == "sunny" then
            if hour >= 21 or hour <= 5 then
                weatherData.icon = "night"
            end
        end

        if weatherData.background == "sunny" then
            if hour >= 21 or hour <= 5 then
                weatherData.background = "night"
            end
        end

        if not weatherData.icon:find("snow") and not weatherData.icon:find("rain") and windSpeed > 10 then
            weatherData.icon = "windy"
        end

        local temperature = math.random(weatherData.temperature[1], weatherData.temperature[2])
        weatherData.temperature = temperature

        if windSpeed > 4 and temperature < 50 then
            -- calculation from https://www.weather.gov/media/epz/wxcalc/windChill.pdf
            local windSpeedMph = windSpeed * 2.236936
            local feelsLike = (35.74 + (0.6215 * temperature) - (35.75 * windSpeedMph ^ 0.16) + (0.4275 * temperature * windSpeedMph ^ 0.16))

            weatherData.feelsLike = math.min(math.floor(feelsLike), temperature)
        end

        local windAngle = math.atan(windDirection.x, windDirection.y) * 180 / math.pi + 180
        weatherData.windAngle = windAngle
        weatherData.windSpeed = windSpeed

        weatherData.city = Config.CityName

        cb(weatherData)
    end
end)
