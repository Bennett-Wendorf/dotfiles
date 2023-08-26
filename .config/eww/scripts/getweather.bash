#!/bin/bash

IFS=', ' read -r -a array <<< $(curl "ipinfo.io/loc?token=$IPINFO_API_KEY")
lat=${array[0]}
lon=${array[1]}

UNIT="imperial" #Options are 'metric' and 'imperial'
weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?appid="$OPENWEATHERMAP_API_KEY"&lat="$lat"&lon="$lon"&units="$UNIT"")
# echo $weather
if [ ! -z "$weather" ]; then
    weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
    weather_icon_code=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
	weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1 | sed -e "s/\b\(.\)/\u\1/g")

	#Big long if statement of doom
	if [ "$weather_icon_code" == "50d"  ]; then
		weather_icon=" "
        weather_quote="Forecast says it's misty"
        weather_hex="#81a1c1"
    elif [ "$weather_icon_code" == "50n"  ]; then
        weather_icon=" "
        weather_quote="Forecast says it's a misty night"
        weather_hex="#81a1c1"
	elif [ "$weather_icon_code" == "01d"  ]; then
        weather_icon=" "
        weather_quote="It's a sunny day, gonna be fun!"
        weather_hex="#d08770"
    elif [ "$weather_icon_code" == "01n"  ]; then
        weather_icon=" "
        weather_quote="It's a clear night"
        weather_hex="#eceff4"
    elif [ "$weather_icon_code" == "02d"  ]; then
        weather_icon=" "
        weather_quote="It's cloudy, sort of gloomy"
        weather_hex="#b48ead"
    elif [ "$weather_icon_code" == "02n"  ]; then
        weather_icon=" "
        weather_quote="It's a cloudy night"
        weather_hex="#b48ead"
    elif [ "$weather_icon_code" == "03d"  ]; then
        weather_icon=" "
        weather_quote="It's cloudy, sort of gloomy"
        weather_hex="#b48ead"
    elif [ "$weather_icon_code" == "03n"  ]; then
        weather_icon=" "
        weather_quote="It's a cloudy night"
        weather_hex="#b48ead"
    elif [ "$weather_icon_code" == "04d"  ]; then
        weather_icon=" "
        weather_quote="It's cloudy, sort of gloomy"
        weather_hex="#b48ead"
    elif [ "$weather_icon_code" == "04n"  ]; then
        weather_icon=" "
        weather_quote="It's a cloudy night"
        weather_hex="#b48ead"
    elif [ "$weather_icon_code" == "09d"  ]; then
        weather_icon=" "
        weather_quote="It's rainy, it's a great day!"
        weather_hex="#5e81ac"
    elif [ "$weather_icon_code" == "09n"  ]; then
        weather_icon=" "
        weather_quote="It's gonna rain tonight it seems"
        weather_hex="#5e81ac"
    elif [ "$weather_icon_code" == "10d"  ]; then
        weather_icon=" "
        weather_quote="It's rainy, it's a great day!"
        weather_hex="#5e81ac"
    elif [ "$weather_icon_code" == "10n"  ]; then
        weather_icon=" "
        weather_quote="It's gonna rain tonight it seems"
        weather_hex="#5e81ac"
    elif [ "$weather_icon_code" == "11d"  ]; then
        weather_icon=""
        weather_quote="There's a storm brewing"
        weather_hex="#ebcb8b"
    elif [ "$weather_icon_code" == "11n"  ]; then
        weather_icon=""
        weather_quote="There's gonna be storms tonight"
        weather_hex="#ebcb8b"
    elif [ "$weather_icon_code" == "13d"  ]; then
        weather_icon=" "
        weather_quote="It's gonna snow today"
        weather_hex="#d8dee9"
    elif [ "$weather_icon_code" == "13n"  ]; then
        weather_icon=" "
        weather_quote="It's gonna snow tonight"
        weather_hex="#d8dee9"
    elif [ "$weather_icon_code" == "40d"  ]; then
        weather_icon=" "
        weather_quote="Forecast says it's misty"
        weather_hex="#81a1c1"
    elif [ "$weather_icon_code" == "40n"  ]; then
        weather_icon=" "
        weather_quote="Forecast says it's a misty night"
        weather_hex="#81a1c1"
    else 
        weather_icon=" "
        weather_quote="Sort of odd, I don't know what to forecast"
        weather_hex="#b48ead"
    fi
else
    weather_icon=" "
    weather_description="Weather Unavailable"
    weather_temp="-"
    weather_quote="Ah well, no weather huh?"
    weather_hex="#b48ead"
fi

echo "{\"icon\":\"$weather_icon\",\"description\":\"$weather_description\",\"temp\":\"$weather_temp°F\",\"quote\":\"$weather_quote\",\"color\":\"$weather_hex\"}"