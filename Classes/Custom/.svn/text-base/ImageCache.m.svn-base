//
//  ImageCache.m
//  ImageCacheTest
//
//  Created by Adrian on 1/28/09.
//  Copyright 2009 Adrian Kosmaczewski. All rights reserved.
//

#import "ImageCache.h"
#import "GTMObjectSingleton.h"
#import "ImageDownloader.h"
#import "AppDelegate.h"
#import "UIImage+FileIO.h"

#import "NSObject+DDExtensions.h"

@interface ImageCache (Private)

- (void)addImageToMemoryCache:(UIImage *)image withKey:(NSString *)key;
- (NSString *)applicationCacheDirectory;
- (NSString *)getFileNameForKey:(NSString *)key;

@end


@implementation ImageCache

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(ImageCache, sharedImageCache)

#pragma mark -
#pragma mark Constructor and destructor

- (id)init
{
    if (self = [super init])
    {
        keyArray = [[NSMutableArray alloc] initWithCapacity:MEMORY_CACHE_SIZE];
        memoryCache = [[NSMutableDictionary alloc] initWithCapacity:MEMORY_CACHE_SIZE];
        fileManager = [NSFileManager defaultManager];
        
        NSString *cacheDirectoryName = [self applicationCacheDirectory];
        BOOL isDirectory = NO;
        BOOL folderExists = [fileManager fileExistsAtPath:cacheDirectoryName isDirectory:&isDirectory] && isDirectory;

        if (!folderExists)
        {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:YES attributes:nil error:&error];
            [error release];
        }
        
        queue = [NSOperationQueue new];
        [queue setMaxConcurrentOperationCount:1];
        
    }
    return self;
}

- (void)dealloc
{
    [keyArray release];
    keyArray = nil;
    [memoryCache release];
    memoryCache = nil;
    fileManager = nil;
    [super dealloc];
}

+ (NSString*) newKeyWithKey:(NSString*)key className:(NSString*)className
{
    return [NSString stringWithFormat:@"%@-%@", key, className];
}

#pragma mark -
#pragma mark Public methods

- (UIImage *)imageForKey:(NSString *)key 
 imageOperationClassName:(NSString *)className
          asyncOperation:(NSOperation**)operation 
                delegate:(id<ImageCacheDelegate>)delegate
{
    
    NSString *preRend = [ImageCache newKeyWithKey:key className:className];
    UIImage *image = [memoryCache objectForKey:preRend];
    if (image == nil && [self imageExistsInDisk:preRend])
    {
		
		SEL sel = @selector(loadForKey:delegate:);
		NSMethodSignature *sig = [self methodSignatureForSelector:sel];

		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:sel];
		[invo setArgument:&preRend atIndex:2];
		[invo setArgument:&delegate atIndex:3];
		
		if (delegate != nil) {

			*operation = [[NSInvocationOperation alloc] initWithInvocation:invo];
			[queue addOperation:*operation];
            //[operation release];
			
		} 
        
    } else if (image == nil && [self imageExistsInDisk:key]) {
        
        SEL sel = @selector(loadForKey:delegate:imageOperationClassName:);
		NSMethodSignature *sig = [self methodSignatureForSelector:sel];
        
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:sel];
		[invo setArgument:&preRend atIndex:2];
		[invo setArgument:&delegate atIndex:3];
        [invo setArgument:&className atIndex:3];
		
		if (delegate != nil) {
            
			*operation = [[NSInvocationOperation alloc] initWithInvocation:invo];
			[queue addOperation:*operation];
            //[operation release];
		} 
    }
	
    return image;
}

- (void)loadForKey:(NSString*)key delegate:(id)delegate imageOperationClassName:(NSString*)className {
    
    if (key == nil) return;
    
   	NSString *fileName = [self getFileNameForKey:key];
    if (fileName == nil) return;
    
    UIImage *img = [UIImage imageFromFile:fileName];
    if (img == nil) return;
    
    UIImage *processedImg = [NSClassFromString(className) process:img];
    [[delegate dd_invokeOnMainThread] imageCache:self imageFromCache:processedImg];
}

- (void)loadForKey:(NSString*)key delegate:(id)delegate
{
    if (key == nil) return;
    
   	NSString *fileName = [self getFileNameForKey:key];
    if (fileName == nil) return;
    
    UIImage *img = [UIImage imageFromFile:fileName];
    if (img == nil) return;
    
	[self addImageToMemoryCache:img withKey:key];
    [[delegate dd_invokeOnMainThread] imageCache:self imageFromCache:img];
}

- (BOOL)hasImageWithKey:(NSString *)key
{
    BOOL exists = [self imageExistsInMemory:key];
    if (!exists) {
        exists = [self imageExistsInDisk:key];
    }
    return exists;
}

- (void)storeImage:(UIImage *)image withKey:(NSString *)key
{
    if (image != nil && key != nil)
    {
        NSString *fileName = [self getFileNameForKey:key];
        [[NSFileManager defaultManager] createDirectoryAtPath:[fileName stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        [image writeImageToFile:fileName];
        [self addImageToMemoryCache:image withKey:key];
    }
}

- (void)removeImageWithKey:(NSString *)key
{
    if ([self imageExistsInMemory:key])
    {
        NSUInteger index = [keyArray indexOfObject:key];
        [keyArray removeObjectAtIndex:index];
        [memoryCache removeObjectForKey:key];
    }

    if ([self imageExistsInDisk:key])
    {
        NSError *error = nil;
        NSString *fileName = [self getFileNameForKey:key];
        [fileManager removeItemAtPath:fileName error:&error];
        [error release];
    }
}

- (void)removeAllImages
{
    [memoryCache removeAllObjects];
    
    NSString *cacheDirectoryName = [self applicationCacheDirectory];
    NSArray *items = [fileManager contentsOfDirectoryAtPath:cacheDirectoryName error:nil];
    for (NSString *item in items)
    {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:item];
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        [error release];
    }
}

- (void)removeAllImagesInMemory
{
    [memoryCache removeAllObjects];
}

- (void)removeOldImages
{
    NSString *cacheDirectoryName = [self applicationCacheDirectory];
    NSArray *items = [fileManager contentsOfDirectoryAtPath:cacheDirectoryName error:nil];
    for (NSString *item in items)
    {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:item];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
        NSDate *creationDate = [attributes objectForKey:NSFileCreationDate];
        if (abs([creationDate timeIntervalSinceNow]) > IMAGE_FILE_LIFETIME)
        {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
        }
    }
}

- (BOOL)imageExistsInMemory:(NSString *)key
{
    return ([memoryCache objectForKey:key] != nil);
}

- (BOOL)imageExistsInDisk:(NSString *)key
{
    NSString *fileName = [self getFileNameForKey:key];
    return [fileManager fileExistsAtPath:fileName];
}

- (NSUInteger)countImagesInMemory
{
    return [memoryCache count];
}

- (NSUInteger)countImagesInDisk
{
    NSString *cacheDirectoryName = [self applicationCacheDirectory];
    NSArray *items = [fileManager directoryContentsAtPath:cacheDirectoryName];
    return [items count];
}

#pragma mark -
#pragma mark Private methods

- (void)addImageToMemoryCache:(UIImage *)image withKey:(NSString *)key
{
    // Add the object to the memory cache for faster retrieval next time
    [memoryCache setObject:image forKey:key];
    
    // Add the key at the beginning of the keyArray
    [keyArray insertObject:key atIndex:0];

    // Remove the first object added to the memory cache
    if ([keyArray count] > MEMORY_CACHE_SIZE)
    {
        // This is the "raison d'etre" de keyArray:
        // we use it to keep track of the last object
        // in it (that is, the first we've inserted), 
        // so that the total size of objects in memory
        // is never higher than MEMORY_CACHE_SIZE.
        NSString *lastObjectKey = [keyArray lastObject];
        [memoryCache removeObjectForKey:lastObjectKey];
        [keyArray removeLastObject];
    }    
}

- (NSString *)getFileNameForKey:(NSString *)key
{
    NSString *cacheDirectoryName = [self applicationCacheDirectory];
    NSString *fileName = [cacheDirectoryName stringByAppendingPathComponent:key];
    return fileName;
}

- (NSString*) applicationCacheDirectory
{
    return [((AppDelegate*)[UIApplication sharedApplication].delegate) applicationImageCacheDirectory];
}

@end
