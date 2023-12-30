# Copyright (c) 2023, Bennett Wendorf. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
from libqtile.widget.generic_poll_text import GenPollUrl
from libqtile import widget
from typing import Any
import requests
import subprocess
from urllib.parse import urlencode

QUERY_URL = "http://api.openweathermap.org/data/2.5/weather?"
DEFAULT_APP_ID = "7834197c2338888258f8cb94ae14ef49"

class OpenWeather(widget.OpenWeather):
    defaults: list[tuple[str, Any, str]] = widget.OpenWeather.defaults + [
        (
            "use_current_location", 
            False, 
            """True to pull the current location using ipinfo.io, 
            False to use the location specified in other parameters.
            Takes precedence over all other location parameters.
            If using this parameter, you must also set ipinfo_api_key.""",
        ),
        (
            "ipinfo_api_key",
            None,
            "API key for ipinfo.io."
        )
    ]

    def __init__(self, **config):
        GenPollUrl.__init__(self, **config)
        self.add_defaults(OpenWeather.defaults)
        self.symbols.update(self.weather_symbols)

    @property
    def url(self):
        if not self.use_current_location and not self.cityid and not self.location and not self.zip and not self.coordinates:
            return None

        params = {
            "appid": self.app_key or DEFAULT_APP_ID,
            "units": "metric" if self.metric else "imperial",
        }
        if self.use_current_location and self.ipinfo_api_key:
            params["lat"], params["lon"] = self._get_current_location()
        elif self.cityid:
            params["id"] = self.cityid
        elif self.location:
            params["q"] = self.location
        elif self.zip:
            params["zip"] = self.zip
        elif self.coordinates:
            params["lat"] = self.coordinates["latitude"]
            params["lon"] = self.coordinates["longitude"]

        if self.language:
            params["lang"] = self.language

        url = QUERY_URL + urlencode(params)
        return url

    def _get_current_location(self):
        res = requests.get(f'https://ipinfo.io/loc?token={self.ipinfo_api_key}', timeout = 1)
        res.raise_for_status()
        return res.text[:-2].split(",")