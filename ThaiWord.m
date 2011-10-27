//
//  ThaiWord.m
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThaiWord.h"

@implementation ThaiWord
@synthesize word;
@synthesize meaning;
@synthesize identifier;
@synthesize examples;
@synthesize reverseExamples;
@synthesize similarWords;

- (id)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

+ (RKObjectMapping *) mapping{
    RKObjectMapping* thaiWordMapping = [RKObjectMapping mappingForClass:[ThaiWord class]];
    [thaiWordMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    [thaiWordMapping mapKeyPath:@"word" toAttribute:@"word"];
    [thaiWordMapping mapKeyPath:@"reverse_examples" toAttribute:@"reverseExamples"];
    [thaiWordMapping mapKeyPath:@"similar_words" toAttribute:@"similarWords"];
    [thaiWordMapping mapKeyPath:@"examples" toAttribute:@"examples"];
    [thaiWordMapping mapKeyPath:@"meaning" toAttribute:@"meaning"];
    return thaiWordMapping;
}

- (void)dealloc {
    [word release];
    [meaning release];
    [identifier release];
    [examples release];
    [reverseExamples release];
    [similarWords release];
    [super dealloc];
}
@end
