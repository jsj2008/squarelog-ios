//
//  ImageModel.h
//  sixhex
//
//  Created by Robert Spychala on 8/8/10.
//  Copyright 2010 VisiScience, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PostModel;

@interface ImageModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * uploadedUrl;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * localPath;
@property (nonatomic, retain) NSDate * dateUploaded;
@property (nonatomic, retain) PostModel * checkin;

@end



