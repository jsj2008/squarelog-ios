//
//  ImageCache.h
//  ImageCacheTest
//
//  Created by Adrian on 1/28/09.
//  Copyright 2009 Adrian Kosmaczewski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageCache;

@protocol ImageCacheDelegate
-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
@end

#define MEMORY_CACHE_SIZE 100

#define IMAGE_FILE_LIFETIME 60*60*24*8

@interface ImageCache : NSObject 
{
@private
    NSMutableArray *keyArray;
    NSMutableDictionary *memoryCache;
    NSFileManager *fileManager;
    NSOperationQueue *queue;
}

+ (ImageCache *)sharedImageCache;

+ (NSString*) newKeyWithKey:(NSString*)key className:(NSString*)className;

- (UIImage *)imageForKey:(NSString *)key 
imageOperationClassName:(NSString*)className
          asyncOperation:(NSOperation**)operation 
                delegate:(id<ImageCacheDelegate>)delegate;

- (BOOL)hasImageWithKey:(NSString *)key;

- (void)storeImage:(UIImage *)image withKey:(NSString *)key;

- (BOOL)imageExistsInMemory:(NSString *)key;

- (BOOL)imageExistsInDisk:(NSString *)key;

- (NSUInteger)countImagesInMemory;

- (NSUInteger)countImagesInDisk;

- (void)removeImageWithKey:(NSString *)key;

- (void)removeAllImages;

- (void)removeAllImagesInMemory;

- (void)removeOldImages;

@end