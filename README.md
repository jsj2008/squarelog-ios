# squarelog-ios

Circa 2010 foursquare client. Not in anyway involved with 4sq other than using their public basic-auth API since 2012 has been shut off.

# Details

Pre tons of features we take for granted now... like ARC, cocoa pods, network stack like af networking, etc, etc

https://github.com/robspychala/squarelog-ios

The marketing website:

http://www.squarelog.com

and example photo the app uploads onto a server I built as well... (in python and running on app engine)

http://www.squarelog.com/van-leeuwen-artisan-ice-cream-store-8Ey

# Technology 

Written for iOS 3.1.3 (though i just changed the dependency to 4.3 to make it work with Xcode 6)

Particularly proud of 

https://github.com/robspychala/squarelog-ios/blob/master/Classes/Data/FourSquare/FSPostQueue.m

serializes network requests to cordite so that upon app crash or quit (this is pre app-backgrounding), the photo, tip, network call would be guaranteed to get execute
