//
//  TLCHistoryViewController.h
//  RollTheDice
//
//  Created by Thomas Caraway on 2/20/15.
//
//

#import <UIKit/UIKit.h>
#import "TLCHistoryEntry.h"
#import "TLCAppDelegate.h"

@interface TLCHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *historyTable;

@property (strong, nonatomic) NSMutableArray *entries;

//history detail view stuff
@property (strong, nonatomic) IBOutlet UIView *historyDetailView;
@property (strong, nonatomic) IBOutlet UILabel *entryFormula;
@property (strong, nonatomic) IBOutlet UILabel *entryTotal;
@property (strong, nonatomic) IBOutlet UITextView *entryRolls;
- (IBAction)backToTable:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

-(void)loadEntries;
-(void)saveEntries;
- (IBAction)clearHistory:(UIButton *)sender;

@end
