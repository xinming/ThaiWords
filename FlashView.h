//
//  FlashView.h
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThaiWord.h"


@interface FlashView : UIScrollView
@property (nonatomic, retain) ThaiWord *word;
@property (nonatomic, retain) UILabel* title;
+ (UILabel *)generateLabel:(NSString *)text withFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame word:(ThaiWord *)theWord;
- (void) initSubviews;
+ (UILabel *)generateGroupedContent:(id)data withFrame:(CGRect)frame maxEntries:(int)maxCount;
@end
