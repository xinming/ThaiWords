//
//  FlashViewController.h
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThaiWord.h"
@interface FlashViewController : UIViewController
@property (nonatomic, retain) ThaiWord *word; 

- (id)initWithWord:(ThaiWord *)thaiWord;

@end
