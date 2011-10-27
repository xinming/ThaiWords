//
//  VocabView.m
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VocabView.h"

@implementation VocabView
@synthesize title, meaning, examples;
- (id)initWithFrame:(CGRect)frame word:(ThaiWord *)word
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization 
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 60)];
        [title setTextAlignment:UITextAlignmentCenter];
        [title setBackgroundColor: [UIColor clearColor]];
        [title setFont:[UIFont fontWithName:@"dtac-Bold" size:46]];
        [title setTextColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [title setText:word.word];
        [self addSubview:title];
        
        CGFloat contentY = 95.0;
        UILabel *meaningLabel = [VocabView generateLabel:@"definition" withFrame:CGRectMake(20, contentY, 280, 20)];
        [self addSubview:meaningLabel];
        
        contentY += 20.0;
        
        meaning = [[MTLabel alloc] initWithFrame:CGRectMake(20, contentY, 280, 25)];
        [meaning setBackgroundColor:[UIColor clearColor]];
        [meaning setFontColor:[UIColor colorWithWhite:0 alpha:0.8]];
        [meaning setNumberOfLines:0];
        [meaning setFont:[UIFont fontWithName:@"dtac-Bold" size:18]];
        [meaning setText:[word.meaning componentsJoinedByString:@", "]];
        [meaning setResizeToFitText:YES];
        [self addSubview:meaning];
        
        contentY += meaning.frame.size.height + 20.0;
        
        if([[word.examples allKeys] count] > 0){
        UILabel *examplesLabel = [VocabView generateLabel:@"examples" withFrame:CGRectMake(20, contentY, 280, 20)];
        [self addSubview:examplesLabel];

        contentY += 20.0;
        examples = [[MTLabel alloc] initWithFrame:CGRectMake(20, contentY, 280, 45)];
        [examples setNumberOfLines:0];
        [examples setBackgroundColor:[UIColor clearColor]];
        
        NSMutableString *examplesText = [NSMutableString stringWithString:@""];
 
        NSArray *keys = [word.examples allKeys];
        int numberOfKeys = [keys count];
        
        for (int i=0; i < (numberOfKeys > 3 ? 3 : numberOfKeys); i ++) {
            [examplesText appendFormat:@"• %@: %@\n", 
             [keys objectAtIndex:i], 
             [(NSArray *)[word.examples objectForKey:[keys objectAtIndex:i]] componentsJoinedByString:@", "]];
        }
        [examples setText:examplesText];
        [examples setFont:[UIFont fontWithName:@"dtac-Bold" size:18]];
        [examples setNumberOfLines:0];
        [examples setResizeToFitText:YES];
        [examples setFontColor:[UIColor colorWithWhite:0 alpha:0.8]];
        
        [self addSubview:examples];
        }
        
//        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"concrete_wall.png"]]];
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
//    UIImage *background = [UIImage imageNamed:@"flash_card_background.png"];
//    [background drawInRect:CGRectMake((320.0-285.0)/2, (480.0 - 394 - 44)/2, 285, 394)];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1);
    CGFloat gray[4] = {0.9f, 0.9f, 0.9f, 1.0f};
    CGContextSetStrokeColor(c, gray);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, 79.5f);
    CGContextAddLineToPoint(c, 320.0f, 79.5f);
    CGContextStrokePath(c);
}

+ (UILabel *)generateLabel:(NSString *)text withFrame:(CGRect)frame{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = text;
    [label setFont:[UIFont fontWithName:@"dtac-Bold" size:18]];
    [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}
- (void)dealloc{
    [self.meaning release];
    [self.title release];
//    [self.examples release];
    [super dealloc];
}

@end
