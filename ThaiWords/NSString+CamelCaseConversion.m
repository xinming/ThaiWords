//
//  NSString+CamelCaseConversion.m
//  ThaiWords
//
//  Created by Xinming Zhao on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+CamelCaseConversion.h"

@implementation NSString (CamelCaseConversion)

// Convert a camel case string into a dased word sparated string.
// In case of scanning error, return nil.
// Camel case string must not start with a capital.
- (NSString *)fromCamelCaseToDashed {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.caseSensitive = YES;
    
    NSString *builder = [NSString string];
    NSString *buffer = nil;
    NSUInteger lastScanLocation = 0;
    
    while ([scanner isAtEnd] == NO) {
        
        if ([scanner scanCharactersFromSet:[NSCharacterSet lowercaseLetterCharacterSet] intoString:&buffer]) {
            
            builder = [builder stringByAppendingString:buffer];
            
            if ([scanner scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&buffer]) {
                
                builder = [builder stringByAppendingString:@" "];
                builder = [builder stringByAppendingString:[buffer lowercaseString]];
            }
        }
        
        // If the scanner location has not moved, there's a problem somewhere.
        if (lastScanLocation == scanner.scanLocation) return nil;
        lastScanLocation = scanner.scanLocation;
    }
    
    return builder;
}

@end
