// 
//  PostModel.m
//  sixhex
//
//  Created by Robert Spychala on 8/8/10.
//  Copyright 2010 VisiScience, Inc. All rights reserved.
//

#import "PostModel.h"

#import "ImageModel.h"

@implementation PostModel 

@dynamic dateUploaded;
@dynamic dateCreated;
@dynamic request;
@dynamic data;
@dynamic images;
@dynamic type;

-(NSArray *)sortedImages 
{
    NSSortDescriptor *sortNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortNameDescriptor, nil] autorelease];
    return [[self.images allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

@end
