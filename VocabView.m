//
//  VocabView.m
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VocabView.h"
#import "NSString+CamelCaseConversion.h"
#import "NSString+HTML.h"

@implementation VocabView
@synthesize title, word;
- (id)initWithFrame:(CGRect)frame word:(ThaiWord *)theWord
{
    self = [super initWithFrame:frame];
    if (self) {
        self.word = theWord;
        // Initialization
        [self initSubviews];
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        
    }
    return self;
}

-(void) initSubviews
{
    title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 60)];
    [title setTextAlignment:UITextAlignmentCenter];
    [title setBackgroundColor: [UIColor clearColor]];
    [title setFont:[UIFont fontWithName:@"dtac-Bold" size:46]];
    [title setTextColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [title setText:word.word];
    [self addSubview:title];
    
    CGFloat contentY = 95.0;
    
    for (NSString * property in [NSArray arrayWithObjects:@"meaning", @"pronounciation", @"examples", @"similarWords", @"reverseExamples", nil]) {
        id data = [word valueForKey:property];
        if(([data isKindOfClass:[NSString class]] && [(NSString *)data length] != 0) || 
           ([data isKindOfClass:[NSArray class]] && [(NSArray *)data count]!= 0)||
           ([data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data allKeys] count] != 0)
        ){
            UILabel *label = [VocabView generateLabel:[property fromCamelCaseToDashed] withFrame:CGRectMake(20, contentY, 280, 20)];
            [self addSubview:label];
            contentY += 24.0;
            UILabel *content = [VocabView generateGroupedContent:data withFrame:CGRectMake(20, contentY, 280, 45) maxEntries:6];
            [self addSubview:content];
            contentY += content.frame.size.height + 25.0;
        }        
    }

    self.contentSize = CGSizeMake(320, contentY);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
//    UIImage *background = [UIImage imageNamed:@"flash_card_background.png"];
//    [background drawInRect:CGRectMake((320.0-285.0)/2, (480.0 - 394 - 44)/2, 285, 394)];
    
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(c, 1);
//    CGFloat gray[4] = {0.75f, 0.75f, 0.75f, 1.0f};
//    CGContextSetStrokeColor(c, gray);
//    CGContextBeginPath(c);
//    CGContextMoveToPoint(c, 20.0f, 79.5f);
//    CGContextAddLineToPoint(c, 300.0f, 79.5f);
//    CGContextStrokePath(c);
}

+ (UILabel *)generateLabel:(NSString *)text withFrame:(CGRect)frame{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = [text uppercaseString];
    [label setFont:[UIFont fontWithName:@"dtac-Bold" size:16]];
    [label setTextColor:[UIColor colorWithWhite:0.65 alpha:1]];
    [label setBackgroundColor:[UIColor whiteColor]];
    return label;
}

+ (UILabel *)generateGroupedContent:(id)data withFrame:(CGRect)frame maxEntries:(int)maxCount{
    
    UILabel *textLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [textLabel setNumberOfLines:0];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    
    NSMutableString *textContent = [NSMutableString stringWithString:@""];
    
    if ([data isKindOfClass: [NSDictionary class]]) {
        NSArray *keys = [(NSDictionary *)data allKeys];
        int numberOfKeys = [keys count];
        
        for (int i=0; i < (numberOfKeys > maxCount ? maxCount : numberOfKeys); i ++) {
            [textContent appendFormat:@"• %@: %@\n", 
             [keys objectAtIndex:i], 
             [(NSArray *)[(NSDictionary *)data objectForKey:[keys objectAtIndex:i]] componentsJoinedByString:@", "]];
        }
    }
    else if([data isKindOfClass: [NSArray class]]){
        [textContent appendString:[(NSArray *)data componentsJoinedByString:@", "]];
    }
    else if([data isKindOfClass: [NSString class]]){
        [textContent appendString:[data stringByDecodingHTMLEntities]];
    }
    
    [textLabel setText:textContent];
    [textLabel setFont:[UIFont fontWithName:@"dtac" size:18]];
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    [textLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.8]];
    return textLabel;
}


- (void)dealloc{
    [self.title release];
    [super dealloc];
}

@end
