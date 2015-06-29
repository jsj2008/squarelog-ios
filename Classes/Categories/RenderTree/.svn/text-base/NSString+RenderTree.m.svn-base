#import <QuartzCore/QuartzCore.h>
#import <ParseKit/ParseKit.h>

#import "UIScreen+Scale.h"

#import "NSString+RenderTree.h"
#import "UIFontAdditions.h"
#import "URLLabel.h"
#import "URLImageView.h"
#import "SLSettings.h"

#import "RenderTreeTextItem.h"
#import "RenderTreeImageItem.h"

#define THUMB_SIZE 75

CGPoint AddText(NSString* text, int *numLines, int maxLines, int lineHeight, int width, 
                UIView* parentTree, UIFont* currentFont, CGPoint currentPoint, UIView *imageView, 
                UIColor* backgroundColor, id delegate)
{
    
    CGSize s  = CGSizeZero;
    if ([text hasPrefix:@"@"] || [text hasPrefix:@"http://"]) {
        s = [text sizeWithFont:[UIFont boldSystemFontOfSize:currentFont.pointSize]];
     } else {
         s = [text sizeWithFont:currentFont];   
     }
    
    if (![text isEqual:@" "] && currentPoint.x + s.width > width && ++*numLines <= maxLines) {
        
        currentPoint.y = currentPoint.y + lineHeight;
        currentPoint.x = 0;
    }
    
    if ([text hasPrefix:@"\n"] && ++*numLines <= maxLines) {
        
        currentPoint.y = currentPoint.y + lineHeight * [text length];
        currentPoint.x = 0;
        
        return currentPoint;
    }
    
    UILabel *l;
    
    if (([text hasPrefix:@"@"] && [text length] > 1) || ([text hasPrefix:@"http://"] && [text length] > 10)) {
        
        l = [[URLLabel alloc] initWithFrame:CGRectMake(currentPoint.x, currentPoint.y, s.width, s.height)];
        ((URLLabel*)l).delegate = delegate;
        
        if (imageView && [text hasPrefix:@"http://sql.to/"]) {
         
            int numberOfPhotos = 1;
            
            NSString *url = text;
            
            NSScanner* scan = [NSScanner scannerWithString:text]; 
            [scan scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"#"] intoString:&url];
            
            if (![scan isAtEnd]) {
                [scan setScanLocation:[scan scanLocation]+1];
                [scan scanInt:&numberOfPhotos];
            }
            
            //_NSLog(@"%@ %@ %d", text, url, numberOfPhotos);
            
            CGPoint point = CGPointZero;
            
            for (int photoCnt = 0; photoCnt < numberOfPhotos && numberOfPhotos <= 8; photoCnt++) {
                
                URLImageView *img = [[URLImageView alloc] initWithFrame:CGRectMake(point.x, point.y, THUMB_SIZE, THUMB_SIZE)];
                img.delegate = delegate;
                img.contentMode = UIViewContentModeScaleAspectFill;
                img.clipsToBounds = YES;
                //img.layer.cornerRadius = 6;
                
                NSString *urlWithOutRedirects = nil;
                if ([[UIScreen mainScreen] backwardsCompatibleScale] > 1) {
                    urlWithOutRedirects = [url stringByReplacingOccurrencesOfString:@"http://sql.to/" withString:[SL_API_BASE_URL stringByAppendingString:@"/photo/thumb-2x/"]];
                } else {
                    urlWithOutRedirects = [url stringByReplacingOccurrencesOfString:@"http://sql.to/" withString:[SL_API_BASE_URL stringByAppendingString:@"/photo/thumb/"]];
                }
                
                img.imageUrl = [NSString stringWithFormat:@"%@?offset=%d", urlWithOutRedirects, photoCnt];
                img.imageUrl2 = [NSString stringWithFormat:@"%@?offset=%d", url, photoCnt];
                [imageView addSubview:img];
                [img release];
                
                point = CGPointMake(point.x + THUMB_SIZE + 10, point.y);
                
                if (point.x + 10 + THUMB_SIZE > width && photoCnt != numberOfPhotos - 1) {
                    point = CGPointMake(0, point.y + 10 + THUMB_SIZE);
                }
                
                if (point.x+THUMB_SIZE > imageView.frame.size.width) {
                    imageView.frame = CGRectMake(0, 0, point.x+THUMB_SIZE, imageView.frame.size.height);
                }
                
                if (point.y+THUMB_SIZE > imageView.frame.size.height) {
                    imageView.frame = CGRectMake(0, 0, imageView.frame.size.width, point.y+THUMB_SIZE);
                }
            }
        }
        
    } else {
        
        l = [[UILabel alloc] initWithFrame:CGRectMake(currentPoint.x, currentPoint.y, s.width, s.height)];
        l.textColor = [UIColor blackColor];
    }
    
    l.backgroundColor = backgroundColor;
    l.text = text;
    l.font = currentFont;
    [parentTree addSubview:l];
    [l release];
    
    currentPoint.x = currentPoint.x + s.width;
    
    return currentPoint;
}

@implementation NSString (RenderTree)

+ (CGFloat) parseUIViewTree:(UIView*)parentTree 
                 fromString:(NSString*)string
                    forFont:(UIFont*)currentFont
                   forWidth:(int)width
                   maxLines:(int)maxLines
              lineBreakMode:(UILineBreakMode)lineBreakMode
   parseImageViewsFromLinks:(BOOL)parseImageViewsFromLinks
            backgroundColor:(UIColor*)backgroundColor
                   delegate:(id)delegate
{
    
    UIView *imageView = nil;
    if (parseImageViewsFromLinks) {
        imageView = [[UIView alloc] initWithFrame:CGRectNull];
    }
    
    int numLines = 1;
    
    CGPoint currentPoint = CGPointMake(0, 0);
    CGFloat lineHeight = [currentFont ttLineHeight];
    
    PKTokenizer *t = [PKTokenizer tokenizerWithString:string];
    t.whitespaceState.reportsWhitespaceTokens = YES;
    t.numberState.allowsTrailingDot = YES;
    [t.symbolState add:@"\n"];
    [t setTokenizerState:t.symbolState from:'\'' to:'\''];
    [t setTokenizerState:t.symbolState from:'"' to:'"'];
    
    PKToken *eof = [PKToken EOFToken];
    PKToken *tok = nil;
    
    while ((tok = [t nextToken]) != eof) {       
        currentPoint = AddText(tok.stringValue, &numLines, maxLines, lineHeight, width, 
                               parentTree, currentFont, currentPoint, imageView, 
                               backgroundColor, delegate);
    }
    
    currentPoint = CGPointMake(currentPoint.x, currentPoint.y+lineHeight);
    
    int imgSize = 0;
    if (imageView && !CGRectEqualToRect(imageView.frame,CGRectNull)) {
        
        currentPoint = CGPointMake(currentPoint.x, currentPoint.y+10);
        imageView.frame = CGRectOffset(imageView.frame, 0, currentPoint.y);
        [parentTree addSubview:imageView];
        imgSize = imageView.frame.size.height;
    }
    
    [imageView release];
    
    return (currentPoint.y + imgSize);
}

+ (CGFloat) parseRenderTree:(NSDictionary*)renderTree fromString:(NSString*)string
                forWidth:(int)width
                maxLines:(int)maxLines
           lineBreakMode:(UILineBreakMode)lineBreakMode
{

	/*
	 
	 example: \\m\\bRobert Spychala \\r@ \\bTaco Bell
	 
	 */
	
	int spacing = 4;
	int numLines = 1;
	
	NSScanner *s = [NSScanner scannerWithString:string];
	
	NSMutableArray *renderItems;
    
    if ([renderTree objectForKey:@"items"]) {
        renderItems = [(NSMutableArray*)[renderTree objectForKey:@"items"] retain];
    } else {
        renderItems = [NSMutableArray new];
        [renderTree setObject:renderItems forKey:@"items"];
    }
	
	NSString *controlCharacter = @"\\r";
	UIFont *currentFont = [UIFont systemFontOfSize:14];
	UIColor *currentColor = [UIColor blackColor];
	UIColor *currentShadow = nil;
    
    CGPoint currentPoint = CGPointMake(0, 0);
    if ([renderTree objectForKey:@"height"]) {
        currentPoint = CGPointMake(0, [(NSNumber*)[renderTree objectForKey:@"height"] intValue]);
    }
    
	while(YES) {
			
		if ([s scanString:@"\\m" intoString:nil]) {
            
            CGFloat lineHeight = [currentFont ttLineHeight];
            
            RenderTreeImageItem *item = [RenderTreeImageItem new];
            item.image = [UIImage imageNamed:@"crown_50x50.png"];
            item.rect = CGRectMake(currentPoint.x, currentPoint.y, lineHeight, lineHeight);
            [renderItems addObject:item];

            currentPoint.x = currentPoint.x + lineHeight + spacing;
            
            currentShadow = nil;
				
		} else if ([s scanString:@"\\r" intoString:&controlCharacter]) {
			
			currentFont = [UIFont systemFontOfSize:14];
			currentColor = [UIColor grayColor];
            currentShadow = nil;

		} else if ([s scanString:@"\\b" intoString:&controlCharacter]) {
			
			currentFont = [UIFont boldSystemFontOfSize:14];
			currentColor = [UIColor blackColor];
            currentShadow = nil;
            
		} else if ([s scanString:@"\\j" intoString:&controlCharacter]) {
			
			currentFont = [UIFont boldSystemFontOfSize:16];
			currentColor = [UIColor darkGrayColor]; 
            currentShadow = [UIColor whiteColor];            
            
		} else if ([s scanString:@"\\h" intoString:&controlCharacter]) {
			
			currentFont = [UIFont boldSystemFontOfSize:16];
			currentColor = [UIColor blackColor]; 
            currentShadow = [UIColor whiteColor];
            
		} else if ([s scanString:@"\\d" intoString:&controlCharacter]) {
			
			currentFont = [UIFont systemFontOfSize:14];
			currentColor = [UIColor blackColor];
            currentShadow = [UIColor whiteColor];
			
		} else if ([s scanString:@"\\q" intoString:&controlCharacter]) {
			
			currentFont = [UIFont boldSystemFontOfSize:15];
			currentColor = [UIColor blackColor]; 
            currentShadow = nil;
            
		} else if ([s scanString:@"\\w" intoString:&controlCharacter]) {
			
			currentFont = [UIFont systemFontOfSize:15];
			currentColor = [UIColor blackColor];
            currentShadow = nil;
        
        } else if ([s scanString:@"\\k" intoString:&controlCharacter]) {
            
            currentFont = [UIFont systemFontOfSize:12];
            currentColor = [UIColor grayColor];
            currentShadow = nil;
            
        } else if ([s scanString:@"\\l" intoString:&controlCharacter]) {
            
            currentFont = [UIFont boldSystemFontOfSize:12];
            currentColor = [UIColor darkGrayColor];
            currentShadow = nil;

		} else if ([s scanString:@"\\n" intoString:&controlCharacter]) {
            
            CGFloat lineHeight = [currentFont ttLineHeight];
			
            currentPoint.y = currentPoint.y + lineHeight;
            currentPoint.x = 0;
            currentShadow = nil;
            
		} else {
            
            CGFloat lineHeight = [currentFont ttLineHeight];
			
			NSString *text;
			if (![s scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&text]) break;
			
			CGSize s = [text sizeWithFont:currentFont];
            
			if (currentPoint.x + spacing + s.width > width && ++numLines <= maxLines) {
                
                CGFloat lineHeight = [currentFont ttLineHeight];
			
				currentPoint.y = currentPoint.y + lineHeight;
				currentPoint.x = 0;
			}
            
            RenderTreeTextItem *item = [RenderTreeTextItem new];
            item.text = text;
			if ((numLines > maxLines)) {
				item.rect = CGRectMake(currentPoint.x, currentPoint.y, width - currentPoint.x, lineHeight);
			} else {
				item.point = currentPoint;
			}
			item.font = currentFont;
			item.color = currentColor;
            if (currentShadow != nil) {
                item.shadowColor = currentShadow;
            }
			[renderItems addObject:item];
            [item release];
			
			if (numLines > maxLines) break;
			
			currentPoint.x = currentPoint.x + spacing + s.width;
		}
	}
    
    CGFloat lineHeight = [currentFont ttLineHeight];
    			 
    [renderItems release];
	[renderTree setObject:[NSNumber numberWithInt:(currentPoint.y + lineHeight)] forKey:@"height"];
    
    return (currentPoint.y + lineHeight);
}

@end
