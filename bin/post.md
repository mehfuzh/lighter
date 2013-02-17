#post
What You Need to Begin iOS Programming

#block

This is a marked down test post. I want to test the capability of marked down and see how it works in the wild.

#Getting started

We want to find a new way to write IOS products. The first thing is to start is by interface builder.

* Display different images for different rows – lastly, we display the same thumbnail for all rows. Wouldn’t be better to show individual image for each recipe?
* Get a developer license
* Start developing.

Location services provide a way to improve your app by enhancing the user experience. If you’re developing a travel app, you can base on the users’ current location to search for nearby restaurants or hotels. 

	#import "Run.h"

	@interface Run ()
	@property (strong) NSDate *primitiveDate;
	@end


	@implementation Run

	@dynamic date, primitiveDate, processID;


	- (void) awakeFromInsert
	{
	    [super awakeFromInsert];
	    self.primitiveDate = [NSDate date];
	}


	- (void)setNilValueForKey:(NSString *)key
	{
	    if ([key isEqualToString:@"processID"]) {
	        self.processID = 0;
	    }
	    else {
	        [super setNilValueForKey:key];
	    }
	}

	@end

You can also find the location feature in most of the Photo apps that saves where the pictures are taken. The Core Location framework provides the necessary Objective-C interfaces for obtaining information about the user’s location. With the GPS coordinate obtained, you can make use of the API to decode the actual street or utilize the Map framework to further display the location on Map.

#block
Mehfuz Hossain

#block
ios

#post
iOS Programming 101: Intro to MapKit API and Add an Annotation on Map

#block

A month ago, we covered how to use Core Location framework to retrieve the user’s location. We also showed you how to convert the GPS coordinate into an address. However, the best way to show a location is to pin it on map. Thanks to the MapKit API. It lets programmers easily work with the built-in Maps and pin a location.

>The Map Kit framework provides an interface for embedding maps directly into your own windows and views. This framework also provides support for annotating the map, adding overlays, and performing reverse-geocoding lookups to determine placemark information for a given map coordinate.

__MapKit__ is a neat API, comes with the iOS SDK, that allows you to display maps, navigate through maps, add annotations for specific locations, add overlays on existing maps, etc. In this tutorial, we’ll walk you though the basics of the API and show you how to place a pin on the map. As usual, rather than going through the theory, we’ll work on a simple app. Through the practice, we hope you’ll get a better idea about MapKit.

#block
Jon Asher

#block
objective-c
