#import <UIKit/UIKit.h>


@interface IdentityOperation : NSOperation {
	
    NSData *dataToParse;
    id delegate;
}

- (id)initWithData:(NSData*)dataToParse delegate:(id)delegate;

@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) id delegate;

@end

@interface AvatarOperation : NSOperation {
    
    NSData *dataToParse;
    id delegate;
}

+ (CGSize) sizeToFit;
+ (CGSize) imageSize;

+ (UIImage*)process:(UIImage*)image;

- (id)initWithData:(NSData*)dataToParse delegate:(id)delegate;

@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) id delegate;

@end

@interface SmallAvatarOperation : AvatarOperation {
}
@end

@interface ThumbOperation : AvatarOperation {
}
@end

@interface BadgeBigOperation : IdentityOperation {
}
@end

@interface BadgeSmallOperation : BadgeBigOperation {
}
@end

@interface WikipediaThumbOperation : AvatarOperation {
}
@end
