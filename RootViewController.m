//
//  RootViewController.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "RootViewController.h"
#import "ThaiWord.h"
#import "FlashViewController.h"
#import "SVProgressHUD.h"

@implementation RootViewController

@synthesize thaiWords, page;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Thai Vocabs";
    self.page = 1;
    self.thaiWords = [NSMutableArray arrayWithObjects: nil];

    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:@"http://ohho.in.th:5000"];
    [manager.router routeClass:[ThaiWord class] toResourcePath:@"/thai_words" forMethod:RKRequestMethodPOST];
    [self index:[NSNumber numberWithInt:page]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", [RKObjectManager sharedManager].router);
}



- (void)create
{
    ThaiWord *aWord = [[ThaiWord alloc] init];
    aWord.word = @"บริษัท";
    NSLog(@"%@", aWord);
    [[RKObjectManager sharedManager] postObject:aWord delegate:self 
                                          block:^(RKObjectLoader *loader) {
                                              RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[ThaiWord class]];
                                              [mapping mapKeyPath:@"thai_word[word]" toAttribute:@"word"];
                                              loader.serializationMapping = [mapping inverseMapping];
                                          }];

}

- (void)index:(NSNumber*) load_page
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/thai_words.json" appendQueryParams:[NSDictionary dictionaryWithObject:load_page forKey:@"page"]]
                         objectMapping:[ThaiWord mapping] delegate:self];
    [SVProgressHUD showWithStatus:@"Loading"];
}



- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
//    NSLog(@"%@", objects);
    [self.thaiWords addObjectsFromArray:objects];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
//    [self.tableView setHidden:NO];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error{
    NSLog(@"%@", error);
}



- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)refreshDisplay:(UITableView *)tableView {
    [tableView reloadData]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.thaiWords count] == 0) {
        return 0;
    }
    return [self.thaiWords count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    if ([indexPath row] == [self.thaiWords count]) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Load"];
        cell.textLabel.text = @"Load More Items...";
        cell.textLabel.textColor = [UIColor colorWithRed:.12 green:.56 blue:.92 alpha:1];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Loaded", [self.thaiWords count]];
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Word";        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        ThaiWord* thaiWord = [self.thaiWords objectAtIndex:[indexPath row]];
        
        cell.textLabel.text = thaiWord.word;
        cell.detailTextLabel.text = [thaiWord.meaning componentsJoinedByString:@", "];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:28];
        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath row] == [self.thaiWords count]) {
        page++;
        [self index:[NSNumber numberWithInt:page]];
    }
    else{
        UIViewController* vc = nil;
        vc = [[FlashViewController alloc] initWithWord:[self.thaiWords objectAtIndex:[indexPath row]]];    
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }    
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
//    [table release];
    [self.thaiWords release];
    [super dealloc];
}

@end
