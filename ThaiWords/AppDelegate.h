//
//  AppDelegate.h
//  ThaiWords
//
//  Created by Xinming Zhao on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "FlashCardListController.h"
#import "VSSpeechSynthesizer.h"
#import "SegmentsController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) VSSpeechSynthesizer *speaker;
@property (nonatomic, retain) SegmentsController     * segmentsController;
@property (nonatomic, retain) UISegmentedControl     * segmentedControl;

- (void)speakWord:(NSString *) text;
- (void)initializeDataMappping;
@end
