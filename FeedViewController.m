//
//  RootViewController.m
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

#import "FeedViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "DetailFeedViewController.h"
#import "SVProgressHUD.h"

@implementation FeedViewController

@synthesize itemsToDisplay, name;

#pragma mark -
#pragma mark View lifecycle

- (id) initWithName:(NSString *)name feedURL: (NSURL *)feedURL{
    self =[super initWithStyle:UITableViewStylePlain];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    return self;
    
}


- (void)viewDidLoad {
    
	// Super
	[super viewDidLoad];
	
	// Setup
	self.title = @"Loading...";
    [[self tableView] setHidden:YES];
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
	// Refresh button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																							target:self 
																							action:@selector(refresh)] autorelease];
	
    [SVProgressHUD showWithStatus:@"Loading"];
    // Parse
	
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
    
}

#pragma mark -
#pragma mark Parsing

// Reset and reparse
- (void)refresh {
    [SVProgressHUD showWithStatus:@"Loading"];
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.3;
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
    [SVProgressHUD dismiss];
	self.title = info.title;
    [[self tableView] setHidden:NO];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];	
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" 
																				 ascending:NO] autorelease]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
    [SVProgressHUD dismiss];
	[self.tableView reloadData];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
	self.title = @"Failed";
	self.itemsToDisplay = [NSArray array];
	[parsedItems removeAllObjects];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsToDisplay.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	// Configure the cell.
	MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
	if (item) {
		
		// Process
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
		
		// Set
		cell.textLabel.font = [UIFont boldSystemFontOfSize:23];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1];
        cell.textLabel.text = [self shortenStringForTableCell:itemTitle withLength:40];
		cell.detailTextLabel.text = [self shortenStringForTableCell:itemSummary withLength:54];
        cell.detailTextLabel.numberOfLines = 1;
	}
    return cell;
}

- (NSString *)shortenStringForTableCell:(NSString *)inputString withLength:(int)length{
    if ([inputString length] > length) {
        return [inputString substringToIndex:length];
    }
    return inputString;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Show detail
	DetailFeedViewController *detail = [[DetailFeedViewController alloc] initWithStyle:UITableViewStylePlain];
	detail.item = (MWFeedItem *)[itemsToDisplay objectAtIndex:indexPath.row];
    detail.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[formatter release];
	[parsedItems release];
	[itemsToDisplay release];
	[feedParser release];
    [name release];

    [super dealloc];
}

@end
