#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface FeedViewController : UITableViewController <MWFeedParserDelegate> {
	
	// Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
	
}

// Properties
@property (nonatomic, retain) NSArray *itemsToDisplay;
@property (nonatomic, retain) NSString *name;

- (NSString *)shortenStringForTableCell:(NSString *)inputString withLength:(int)length;
- (id) initWithName:(NSString *)name feedURL: (NSURL *)feedURL;
@end
