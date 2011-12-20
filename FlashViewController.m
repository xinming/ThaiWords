//
//  FlashViewController.m
//  IOSBoilerplate
//
//  Created by Xinming Zhao on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlashViewController.h"
#import "FlashView.h"
#import "ThaiWord.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation FlashViewController
@synthesize word;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithWord:(ThaiWord *)thaiWord{
    self = [super init];
    if (self) {
        self.word = thaiWord;
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    FlashView *vv = [[[FlashView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) word:self.word] autorelease];
    self.view = vv;
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;    
    [self.navigationController.toolbar setTintColor:[UIColor colorWithWhite:0.3 alpha:1]];
    self.navigationController.toolbar.layer.shadowOffset = CGSizeMake(0, -1);
    self.navigationController.toolbar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.toolbar.layer.shadowOpacity = 0.5;
    self.navigationController.toolbar.layer.shadowRadius = 1;
    self.navigationController.toolbar.layer.shouldRasterize = YES;
    
    UIBarButtonItem *speakButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
                                                                                 target:self 
                                                                                 action:@selector(speakWord)] autorelease];

    UIBarButtonItem *deleteButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
                                                                                  target:self 
                                                                                  action:@selector(promptDeleteWord)] autorelease];

    UIBarButtonItem	*fixed = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                            target:nil 
                                                                            action:nil] autorelease];
    fixed.width = 10.0;
    UIBarButtonItem	*flex = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                           target:nil 
                                                                           action:nil] autorelease];

    
    [self setToolbarItems:[NSArray arrayWithObjects:fixed, speakButton, flex, deleteButton, fixed, nil]];
}


- (void) viewDidAppear:(BOOL)animated{
    
}

- (void)speakWord{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] speakWord:self.word.word];
}

- (void)promptDeleteWord
{
    UIAlertView * deletePrompt = [[[UIAlertView alloc] initWithTitle:@"Confirmation" 
                                                            message:@"Are you sure to delete this word? " 
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel" 
                                                  otherButtonTitles:@"OK", nil] autorelease];
    [deletePrompt show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteWord];
    }
}

- (void)deleteWord{
    FlashCardListController *parentController = (FlashCardListController *)[self.navigationController.viewControllers objectAtIndex:0];
    [[RKObjectManager sharedManager] deleteObject:self.word 
                                         delegate:parentController];


    [parentController.thaiWords removeObject:self.word];
    [parentController.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
