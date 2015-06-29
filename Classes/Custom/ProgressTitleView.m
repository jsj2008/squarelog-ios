#import <math.h>
#import <QuartzCore/QuartzCore.h>

#import "ProgressTitleView.h"
#import "FSPostQueue.h"
#import "UIFontAdditions.h"
#import "ReachabilityHelper.h"

#import "PostModel+Extra.h"

#define ERROR_VIEW_TAG 1111
#define TITLE_VIEW_TAG 2222
#define PROGRESS_VIEW_TAG 3333

@implementation ProgressTitleView

@synthesize title;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
        
        
        // add title
        
        {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [[UIFont boldSystemFontOfSize:20] ttLineHeight])];
            l.textAlignment = UITextAlignmentCenter;
            l.font = [UIFont boldSystemFontOfSize:20];
            l.shadowColor = [UIColor darkGrayColor];
            l.shadowOffset = CGSizeMake(0, -1);
            l.textColor = [UIColor whiteColor];
            l.center = self.center;
            l.frame = CGRectMake(l.frame.origin.x, l.frame.origin.y-1, l.frame.size.width, l.frame.size.height);
            l.backgroundColor = [UIColor clearColor];
            //l.backgroundColor = [UIColor redColor];
            l.tag = TITLE_VIEW_TAG;
            [self addSubview:l];
            [l release];
            
            titlePointNormal = CGPointMake(l.frame.origin.x, l.frame.origin.y);
            titlePointUp = CGPointMake(l.frame.origin.x, titlePointNormal.y - 6);
        }
                
        // add progress & error
        
        {
            
            // progress
            
            UIProgressView *p = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
            p.center = self.center;
            p.frame = CGRectMake(p.frame.origin.x, (int)p.frame.origin.y+12, p.frame.size.width, p.frame.size.height);
            p.tag = PROGRESS_VIEW_TAG;
            p.hidden = YES;
            [self addSubview:p];
            [p release];
            
            // error
            
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [[UIFont boldSystemFontOfSize:12] ttLineHeight])];
            l.textAlignment = UITextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:12];
            l.shadowColor = [UIColor darkGrayColor];
            l.shadowOffset = CGSizeMake(0, -1);
            l.textColor = [UIColor whiteColor];
            l.center = self.center;
            l.frame = CGRectMake(l.frame.origin.x, p.frame.origin.y-4, l.frame.size.width, l.frame.size.height);
            l.backgroundColor = [UIColor clearColor];
            //l.backgroundColor = [UIColor purpleColor];
            l.tag = ERROR_VIEW_TAG;
            
            l.hidden = YES;
            [self addSubview:l];
            [l release];
        }        
        
        // display link
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawTimerView)];
        [displayLink setFrameInterval:60];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        displayLink.paused = YES;
        
		[[FSPostQueue sharedInstance] addObserver:self
                                       forKeyPath:@"error"
                                          options:(NSKeyValueObservingOptionNew)
                                          context:NULL];          
		
		[[FSPostQueue sharedInstance] addObserver:self
                                       forKeyPath:@"progress"
                                          options:(NSKeyValueObservingOptionNew)
                                          context:NULL];
        
        //[self exploreViewAtLevel:0];
    }
    return self;
}

- (void) setTitle:(NSString *) t
{
	((UILabel*)[self viewWithTag:TITLE_VIEW_TAG]).text = t;
}

- (void) drawTimerView
{
    
    NSTimeInterval t = [[FSPostQueue sharedInstance].failedDate timeIntervalSinceNow];
    UILabel *l = ((UILabel*)[self viewWithTag:ERROR_VIEW_TAG]);
    
    if (RETRY_TIME_SECONDS+(int)t > 0) {
        l.text  = [NSString stringWithFormat:@"Error. Retrying in %d seconds.", RETRY_TIME_SECONDS+(int)t];
        //l.hidden = NO;
    } else {
        l.hidden = YES;
        displayLink.paused = YES;
        UIProgressView *p = ((UIProgressView*)[self viewWithTag:PROGRESS_VIEW_TAG]);
        p.hidden = NO;
    }
    
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    LOG_EXPR(change);
    
    if ([keyPath isEqual:@"progress"]) {
        
        displayLink.paused = YES;
		
        float newProgress = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] floatValue];
		
        LOG_EXPR(newProgress);
        
		if (newProgress != 1) {

			[self adjustTitle:@"up"];
            
            UIProgressView *p = ((UIProgressView*)[self viewWithTag:PROGRESS_VIEW_TAG]);
            p.progress = newProgress;
            p.hidden = NO;
            
		} else if (newProgress == 1) {
						
			[self performSelector:@selector(adjustTitle:) withObject:@"normal" afterDelay:.5];
		}
        
        UILabel *e = ((UILabel*)[self viewWithTag:ERROR_VIEW_TAG]);
        e.hidden = YES;
        
	} else if ([keyPath isEqual:@"error"]) {
        
        [self adjustTitle:@"up"];
        
        UIProgressView *p = ((UIProgressView*)[self viewWithTag:PROGRESS_VIEW_TAG]);
        p.hidden = YES;
        
        UILabel *e = ((UILabel*)[self viewWithTag:ERROR_VIEW_TAG]);
        e.hidden = NO;
        
        if ([ReachabilityHelper sharedInstance].isConnected) {
            
            NSTimeInterval t = [[FSPostQueue sharedInstance].failedDate timeIntervalSinceNow];
        
            e.text  = [NSString stringWithFormat:@"Error. Retrying in %d seconds.", RETRY_TIME_SECONDS+(int)t];
            displayLink.paused = NO;
            
        } else {
            
            int itemCount = 0;
            for (PostModel *post in [PostModel notUploadedPosts]) {
                itemCount++;
                itemCount += [post.images count];
            }
            
            e.text  = [NSString stringWithFormat:@"Queued %d items.", itemCount];
        }
    }
}

- (void)adjustTitle:(NSString*)direction
{
	
	if ([direction isEqualToString:@"normal"]) {
        UIProgressView *p = ((UIProgressView*)[self viewWithTag:PROGRESS_VIEW_TAG]);
        p.hidden = YES;
    }
	
	[UIView beginAnimations:@"anim" context:NULL];
	[UIView setAnimationDuration:.2];
	[UIView setAnimationDelegate:self];
	
    if ([direction isEqualToString:@"up"]) {
        [self viewWithTag:TITLE_VIEW_TAG].frame = CGRectMake(titlePointUp.x, titlePointUp.y, 
                                                             [self viewWithTag:TITLE_VIEW_TAG].frame.size.width, [self viewWithTag:TITLE_VIEW_TAG].frame.size.height);
    } else {
        [self viewWithTag:TITLE_VIEW_TAG].frame = CGRectMake(titlePointNormal.x, titlePointNormal.y, 
                                                             [self viewWithTag:TITLE_VIEW_TAG].frame.size.width, [self viewWithTag:TITLE_VIEW_TAG].frame.size.height);        
    }
	
	[UIView commitAnimations];
}

- (void)dealloc {
	
	[[FSPostQueue sharedInstance] removeObserver:self forKeyPath:@"progress"];
    [[FSPostQueue sharedInstance] removeObserver:self forKeyPath:@"error"];
    [super dealloc];
}


@end
