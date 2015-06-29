#import "PostModel+Extra.h"
#import "AppDelegate.h"

@implementation PostModel (Extra)

// grab last uploaded image
- (ImageModel*) lastUploadedImage:(NSNumber**)picCount
{
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:ManagedObjectContext()];
    [request setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"checkin == %@", self];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO] autorelease];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, nil]];
    
    NSError* error = nil;
    NSArray* results = [ManagedObjectContext() executeFetchRequest:request error:&error];
    [error release]; error = nil;
    
    *picCount = [NSNumber numberWithInt:[results count]];
    
    ImageModel *image = (ImageModel*) [results lastObject];
    
    return image;
}

+ (NSString*) addURLToShout:(NSString*)shout url:(NSString*)url numberOfPics:(int)picCount
{
    
    if (picCount > 0) {
        
        url = [NSString stringWithFormat:@"%@%@", 
                        url, picCount>1?[NSString stringWithFormat:@"#%d", picCount]:@""];
        
        if (!shout || [shout length] == 0) shout = [NSString stringWithFormat:@"%@: %@", 
                             picCount>1?@"photos":@"photo", 
                             url];
        else shout = [NSString stringWithFormat:@"%@ %@", shout, url];
        
        return shout;
        
    } else {
        
        return shout;
    }
}

+ (NSArray*) notUploadedPosts
{
 
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:ManagedObjectContext()];
	[request setEntity:entity];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"dateUploaded == NULL"];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor1 = [[[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES] autorelease];
	[request setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, nil]];
	
	NSError* _error = nil;
	NSArray* results = [ManagedObjectContext() executeFetchRequest:request error:&_error];
    
    return results;
}

@end
