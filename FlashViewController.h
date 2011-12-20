//
//  FlashViewController.h
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThaiWord.h"
@interface FlashViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, retain) ThaiWord *word; 

- (id)initWithWord:(ThaiWord *)thaiWord;
- (void)deleteWord;
- (void)promptDeleteWord;
- (void)speakWord;
@end
