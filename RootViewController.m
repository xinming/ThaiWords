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

@synthesize thaiWords, page, isCompleted, alertBox;


- (id)initWithName:(NSString *)name completed:(BOOL)completed{
    self = [super initWithStyle:UITableViewStylePlain];
    if (completed) {
        self.isCompleted = YES;
        self.title = @"Review";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Review" image:[UIImage imageNamed:@"review.png"] tag:1];
    }else{
        self.isCompleted = NO;
        self.title = @"Vocabs";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Vocabs" image:[UIImage imageNamed:@"vocabs.png"] tag:2];

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
    self.thaiWords = [NSMutableArray arrayWithObjects: nil];
    
    [self index:[NSNumber numberWithInt:page]];
//    UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithTitle:@"Refresh" 
//                                                                      style:UIBarButtonItemStylePlain target:self action:@selector(refresh)] autorelease];
    
    UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];

    
    self.navigationItem.leftBarButtonItem = refreshButton;
    
    
    if(!self.isCompleted){
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWord)] autorelease];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



- (void) refresh
{
    self.page = 1;
    [self.thaiWords removeAllObjects];
    [self index:[NSNumber numberWithInt:1]];
}

- (void) addWord
{    
    alertBox = [[UIAlertView alloc] initWithTitle:@"New Vocab" 
                                          message:@"\n\n"
                                         delegate:self 
                                cancelButtonTitle:NSLocalizedString(@"Cancel",nil) 
                                otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(14,58,256,30)];
    passwordField.font = [UIFont systemFontOfSize:18];
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.borderStyle = UITextBorderStyleBezel;
    passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [passwordField becomeFirstResponder];
    [alertBox addSubview:passwordField];
    
    [alertBox show];
    [alertBox release];
    [passwordField release];    
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        NSString *input = [[(UITextView *)[[alertBox subviews] lastObject] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        ThaiWord *word = [[ThaiWord alloc] init];
        word.word = input;
        [[RKObjectManager sharedManager] postObject:word delegate:self];
        
    }
}


- (void)index:(NSNumber*)load_page
{
    [SVProgressHUD showWithStatus:@"Loading"];

    
    
    NSDictionary *params;
    if(self.isCompleted){
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                load_page, @"page",
                                [NSNumber numberWithInt:1], @"completed",
                                nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                load_page, @"page",
                                [NSNumber numberWithInt:1], @"to_be_completed",
                                nil];
    }

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/thai_words.json" appendQueryParams: params]
                                                  objectMapping:[ThaiWord mapping] delegate:self];
}



- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    [self.thaiWords addObjectsFromArray:objects];
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object{
    NSLog(@"did load object : %@", object);
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
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
        cell.textLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1];
        cell.detailTextLabel.text = [thaiWord.meaning componentsJoinedByString:@", "];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:26];
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
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }    
    }


}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return YES or NO
    if([indexPath row] == [self.thaiWords count]){
        return NO;
    }
    
    return(!self.isCompleted);
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Complete";
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThaiWord *word = [thaiWords objectAtIndex:[indexPath row]];
    [word setIsDone:YES];
    [[RKObjectManager sharedManager] putObject:word delegate:self];
    [self.thaiWords removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
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
