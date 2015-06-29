#import "NSDictionary+REST.h"

@implementation NSDictionary(REST)

/// HTTP post data (flattened) lines
//
// Returns: HTTP post data key-value pairs, keys are []'ed
- (NSMutableArray *) RESTArrayHTTPPostData {
	
	// Flatten the dictionary
	NSMutableArray *flattened = [NSMutableArray array];
	NSMutableArray *objects = [NSMutableArray arrayWithObject: self];
	NSMutableArray *paths = [NSMutableArray arrayWithObject: [NSMutableArray array]];
	while ([objects count] > 0) {
		id object = [objects lastObject];
		[objects removeLastObject];
		NSMutableArray *path = [paths lastObject];
		[paths removeLastObject];
		if ([object isKindOfClass: NSClassFromString(@"NSDictionary")]) {
			for (NSString *key in [object allKeys]) {
				NSMutableArray *pathWithKey = [NSMutableArray arrayWithArray: path];
				
				// We can be at the root and we need a key without []'thingys
				if ([pathWithKey count] == 0)
					[pathWithKey addObject: [NSString stringWithFormat: @"%@", key]];
				else
					[pathWithKey addObject: [NSString stringWithFormat: @"[%@]", key]];
				[paths addObject: pathWithKey];
				[objects addObject: [object objectForKey: key]];
			}
		} else if ([object isKindOfClass: NSClassFromString(@"NSArray")]) {
			for (int i = 0; i < [object count]; i++) {
				NSMutableArray *pathWithKey = [NSMutableArray arrayWithArray: path];
				[pathWithKey addObject: [NSString stringWithFormat: @"[%i]", i]];
				[paths addObject: pathWithKey];
				[objects addObject: [object objectAtIndex: i]];
			}
		} else {
			[flattened insertObject: [NSArray arrayWithObjects:
									  [path componentsJoinedByString: @""],
									  object,
									  nil]
							atIndex: 0];
		}
	}
	return flattened;
}

//http://github.com/mirek/NSMutableDictionary-REST.framework/blob/master/NSMutableDictionary%2BREST.m
/// Generate HTTP post data body from the dictionary
//
// Returns: HTTP post data
- (NSString *) RESTURLEncodedHTTPPostData {
	NSMutableArray *lines = [NSMutableArray array];
	for (NSArray *pair in [self RESTArrayHTTPPostData]) {
		NSMutableArray *escapedPair = [NSMutableArray arrayWithCapacity: 2];
		for (id element in pair)
			[escapedPair addObject: (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																						(CFStringRef)[NSString stringWithFormat: @"%@", element],
																						NULL,
																						(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						kCFStringEncodingUTF8)];
		[lines addObject: [escapedPair componentsJoinedByString: @"="]];
	}
	return [lines componentsJoinedByString: @"&"];
}

- (NSData*) RESTMultipartHTTPPostDataWithBoundary:(NSString*)boundary
{
	
	NSArray* keys = [self allKeys];
	NSMutableData* result = [[NSMutableData alloc] initWithCapacity:1100000];
	
	int i;
	for (i = 0; i < [keys count]; i++) 
	{
		id value = [self objectForKey: [keys objectAtIndex: i]];
		[result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if ([value isKindOfClass:[NSString class]])
		{
			[result appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];	
			[result appendData:[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:NSUTF8StringEncoding]];
		}
		else if ([value isKindOfClass:[NSArray class]]) {
			
			[result appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [keys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];	
			[result appendData:[[NSString stringWithFormat:@"%@",[((NSArray*) value) componentsJoinedByString:@","]] dataUsingEncoding:NSUTF8StringEncoding]];
			
		}
		else if ([value isKindOfClass:[NSData class]])
		{
			[result appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [keys objectAtIndex:i], @"iphone.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
			[result appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			[result appendData:value];
		}
		[result appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[result appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	return result;
}

@end
