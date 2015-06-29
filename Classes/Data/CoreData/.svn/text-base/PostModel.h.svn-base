//
//  PostModel.h
//  sixhex
//
//  Created by Robert Spychala on 8/8/10.
//  Copyright 2010 VisiScience, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ImageModel;

@interface PostModel :  NSManagedObject  
{
}

@property (readonly) NSArray *sortedImages;

@property (nonatomic, retain) NSDate * dateUploaded;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSData * request;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet* images;

@end


@interface PostModel (CoreDataGeneratedAccessors)
- (void)addImagesObject:(ImageModel *)value;
- (void)removeImagesObject:(ImageModel *)value;
- (void)addImages:(NSSet *)value;
- (void)removeImages:(NSSet *)value;

@end

