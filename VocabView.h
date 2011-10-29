//
//  VocabView.h
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThaiWord.h"
//#import "MTLabel.h"

@interface VocabView : UIView
@property (nonatomic, retain) UILabel* title;
@property (nonatomic, retain) UILabel *meaning;
@property (nonatomic, retain) UILabel *examples;
+ (UILabel *)generateLabel:(NSString *)text withFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame word:(ThaiWord *)word;
@end
