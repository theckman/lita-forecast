lita-forecast
=============
[![Build Status](https://img.shields.io/travis/theckman/lita-forecast/master.svg)](https://travis-ci.org/theckman/lita-forecast)
[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://tldrlegal.com/license/mit-license)
[![RubyGems :: RMuh Gem Version](http://img.shields.io/gem/v/lita-forecast.svg)](https://rubygems.org/gems/lita-forecast)
[![Coveralls Coverage](https://img.shields.io/coveralls/theckman/lita-forecast/master.svg)](https://coveralls.io/r/theckman/lita-forecast)
[![Code Climate](https://img.shields.io/codeclimate/github/theckman/lita-forecast.svg)](https://codeclimate.com/github/theckman/lita-forecast)
[![Gemnasium](https://img.shields.io/gemnasium/theckman/lita-forecast.svg)](https://gemnasium.com/theckman/lita-forecast)

Forecast.io plugin for Lita

LICENSE
-------
[lita-forecast](https://github.com/theckman/lita-forecast) is released under
the [MIT](http://opensource.org/licenses/MIT) license. The full license is
provided in the `LICENSE` file.

CONTRIBUTING
------------
Something wrong or you want to submit an improvement? Fork the repo, make your
changes on a feature branch, write some tests, and submit a pull request. I
only ask that the commits have useful information and use proper/complete
sentences.

INSTALLATION
------------
Simply add `lita-forecast` to the `Gemfile` for your Lita instance.

```Ruby
gem 'lita-forecast'
```

CONFIGURATION
-------------
There is only one required configuration option for this plugin, and that's
your Forecast.io API key
[Forecast.io Developer Site](https://developer.forecast.io/register)

```Ruby
config.handlers.forecast.api_key = '<API_KEY>'
```

COMMANDS
-----
* `wx <alias/location>` - get the weather forecast for a location in US units.
* `wc <alias/location>` - get the weather forecast for a location in CA units.
* `ws <location>` - returns the lat. and long. for your search string so that
  you can add a weather alias
* `wl` - list known weather aliases
* `wadd <alias> <lat> <long> [<description>]` - add an alias to your bot
* `wrm alias` - remove an alias added to your bot

USAGE
-----
```
>> Lita wx San Francisco, CA
San Francisco, CA:

Now: 55.5F (feels like 55.5F) Mostly Cloudy; Winds WSW 8.6mph; Humidity 66%; Dew Pt 44.2F; Pressure 1019.2mb; Cloud cover 82%.
Next hour: Mostly cloudy for the hour. Next 24h: Rain throughout the day.

Summary: Light rain today through Thursday, with temperatures bottoming out at 52°F on Tuesday.
Today: Mostly cloudy throughout the day. High 57F, Low 51F. 90% chance of rain. Winds W 7mph.
Tomorrow: Rain throughout the day. High 55F, Low 51F. 100% chance of rain. Winds SSW 9mph.

>> Lita wc San Francisco, CA
San Francisco, CA:

Now: 13.1C (feels like 13.1C) Mostly Cloudy; Winds WSW 12.6kmph; Humidity 65%; Dew Pt 6.7C; Pressure 1019.2mb; Cloud cover 82%.
Next hour: Mostly cloudy for the hour. Next 24h: Rain throughout the day.

Summary: Light rain today through Thursday, with temperatures bottoming out at 11°C on Tuesday.
Today: Mostly cloudy throughout the day. High 14C, Low 10C. 90% chance of rain. Winds W 11kmph.
Tomorrow: Rain throughout the day. High 13C, Low 10C. 100% chance of rain. Winds SSW 15kmph.

>> Lita wl
There are no weather aliases

>> Lita ws 501 2nd St, 94107
San Francisco, CA: 37.7830503, -122.3933962 :: !wadd <alias> 37.7830503 -122.3933962 <description/city name>

>> Lita wadd sf 37.7749295 -122.4194155 PagerDuty San Francisco
sf added to the cache at [37.7749295, -122.4194155]

>> Lita wx sf
PagerDuty San Francisco:

Now: 55.6F (feels like 55.6F) Mostly Cloudy; Winds WSW 7.8mph; Humidity 65%; Dew Pt 44.0F; Pressure 1019.2mb; Cloud cover 82%.
Next hour: Mostly cloudy for the hour. Next 24h: Rain throughout the day.

Summary: Light rain today through Thursday, with temperatures bottoming out at 52°F on Tuesday.
Today: Mostly cloudy throughout the day. High 57F, Low 51F. 90% chance of rain. Winds W 7mph.
Tomorrow: Rain throughout the day. High 55F, Low 51F. 100% chance of rain. Winds SSW 9mph.

>> Lita wl
Known weather aliases: sf

>> Lita wrm sf
Alias removed!
```
