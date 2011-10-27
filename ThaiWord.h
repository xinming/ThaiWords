//
//  ThaiWord.h
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


@interface ThaiWord : NSObject

@property (nonatomic,retain) NSString * word;
@property (nonatomic,retain) NSArray * meaning;
@property (nonatomic,retain) NSNumber * identifier;
@property (nonatomic,retain) NSDictionary *examples;
@property (nonatomic,retain) NSDictionary *reverseExamples;
@property (nonatomic,retain) NSDictionary *similarWords;

+ (RKObjectMapping *) mapping;
@end
