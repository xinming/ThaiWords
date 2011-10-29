//
//  DetailTableViewController.m
//  MWFeedParser
//
//  Copyright (c) 2010 Michael Waterfall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//  
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the 
//     purpose of any concept relating to diary/journal keeping.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DetailTableViewController.h"
#import "NSString+HTML.h"
#import <QuartzCore/QuartzCore.h>

typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderDate, SectionHeaderURL } HeaderRows;
typedef enum { SectionDetailSummary } DetailRows;

@implementation DetailTableViewController

@synthesize item, dateString, summaryString, textV;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
	// Super
    [super viewDidLoad];
    

    UIBarButtonItem *speakButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(speakWord)];
    [self.navigationItem setRightBarButtonItem:speakButton];
    [speakButton release];

    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Add Word" action:@selector(addWord)];
    UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"Speak" action:@selector(speakWord)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem, menuItem2, nil]];
    [menuItem release]; 
    [menuItem2 release];

	// Date
	if (item.date) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
		self.dateString = [formatter stringFromDate:item.date];
		[formatter release];
	}
	
	// Summary
	if (item.summary) {
		self.summaryString = [item.summary stringByConvertingHTMLToPlainText];
	} else {
		self.summaryString = @"[No Summary]";
	}
    
    
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Icon.png"]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"project_papper.png"]];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.2 alpha:0.15];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 0: return 3;
		default: return 1;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Get cell
	static NSString *CellIdentifier = @"CellA";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Display
	cell.textLabel.textColor = [UIColor blackColor];
	cell.textLabel.font = [UIFont systemFontOfSize:15];
	if (item) {
		
		// Item Info
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		// Display
		switch (indexPath.section) {
			case SectionHeader: {
				
				// Header
				switch (indexPath.row) {
					case SectionHeaderTitle:
						cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
                        cell.textLabel.numberOfLines = 2;
						cell.textLabel.text = itemTitle;
						break;
					case SectionHeaderDate:
						cell.textLabel.text = dateString ? dateString : @"[No Date]";
                        cell.textLabel.font = [UIFont systemFontOfSize:12];
                        cell.textLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
						break;
					case SectionHeaderURL:
						cell.textLabel.text = item.link ? item.link : @"[No Link]";
                        cell.textLabel.font = [UIFont systemFontOfSize:12];
//						cell.textLabel.textColor = [UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
                        cell.textLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
						cell.selectionStyle = UITableViewCellSelectionStyleBlue;
						break;
				}
				break;
				
			}
			case SectionDetail: {
                textV=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - 20 - 54 - 34 - 34 - 44)];
                textV.font = [UIFont systemFontOfSize:18.0];
                textV.text=summaryString;
                textV.textColor=[UIColor blackColor];
                textV.editable=NO;
                [cell.contentView addSubview:textV];
				break;
				
			}
		}
	}
    
    
    
    return cell;
	
}

- (void)addWord
{
    
    ThaiWord *aWord = [[ThaiWord alloc] init];
    
    aWord.word = [self.textV.text substringWithRange:[self.textV selectedRange]];
    [[RKObjectManager sharedManager] postObject:aWord delegate:self];
    [aWord release];
}

- (void)speakWord{
    NSObject *v = [[NSClassFromString(@"VSSpeechSynthesizer") alloc] init];
    NSString *text;
    if (self.textV.selectedRange.length > 0) {
        text = [self.textV.text substringWithRange:[self.textV selectedRange]]; 
    }
    else{
        text = self.textV.text;
    }
    
    [v startSpeakingString:text];
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor whiteColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == SectionHeader) {
        switch (indexPath.row) {
            case SectionHeaderTitle:
                return 54;
                break;
            case SectionHeaderDate:
            case SectionHeaderURL:
                return 34;
                break;
        }
    }

    return 480 - 20 - 54 - 34 - 34 - 44;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// Open URL
	if (indexPath.section == SectionHeader && indexPath.row == SectionHeaderURL) {
		if (item.link) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.link]];
		}
	}
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[dateString release];
	[summaryString release];
	[item release];
    [super dealloc];
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(addWord) || action == @selector(speakWord)) {
        if (self.textV.selectedRange.length > 0) {
            return YES;
        }
    }
    
    return NO; }


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"did load object : %@", object);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"%@", error);
}


@end

