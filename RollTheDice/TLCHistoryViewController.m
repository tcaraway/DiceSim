//
//  TLCHistoryViewController.m
//  RollTheDice
//
//  Created by Thomas Caraway on 2/20/15.
//
//

#import "TLCHistoryViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TLCHistoryViewController () <UIAlertViewDelegate>

@end

@implementation TLCHistoryViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.historyTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    //loads history entries saved in memory
    [self loadEntries];
    [self.historyTable reloadData];
    
    //shadows for detail view
    CALayer *layer = self.historyDetailView.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
    self.entryTotal.clipsToBounds = YES;
    self.entryTotal.layer.cornerRadius = 8;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




//TABLE VIEW FUNCTIONS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entries count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HistoryEntry";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        //Adding "Formula : Total" Label for cell
        UILabel *formulaAndTotal = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 400.0, 30.0)];
        [formulaAndTotal setTag:1];
        [formulaAndTotal setBackgroundColor:[UIColor clearColor]];
        [formulaAndTotal setFont:[UIFont boldSystemFontOfSize:20.0]];
        formulaAndTotal.textColor = [UIColor colorWithRed:.5 green:0 blue:0 alpha:1.0];
        [cell.contentView addSubview:formulaAndTotal];
        
        
    }
    
    //WHAT DISPLAYS ON THE CELL
    TLCHistoryEntry *entry = [self.entries objectAtIndex:indexPath.row];
    NSString *formula = entry.formula;
    NSString *total = entry.total;
    //NSString *individualRolls = entry.individualRolls;
    [(UILabel *)[cell.contentView viewWithTag:1] setText:[NSString stringWithFormat:@"%@  :  %@",formula,total]];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@",formula,total,individualRolls];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


//when cell is selected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLCHistoryEntry *detailEntry = [self.entries objectAtIndex:indexPath.row];
    self.entryFormula.text = detailEntry.formula;
    self.entryTotal.text = detailEntry.total;
    self.entryRolls.text = detailEntry.individualRolls;
    
    self.entryRolls.layer.cornerRadius = 8;
    self.entryTotal.layer.cornerRadius = 8;
    self.backButton.layer.cornerRadius = 8;
    
    self.clearButton.enabled = NO;
    self.clearButton.hidden = YES;
    [self animateDetailView];
}




//Brings detail view onto screen
-(void)animateDetailView
{
    [UIView animateWithDuration:0.5 animations:^{
        _historyDetailView.frame = CGRectMake(0, 63, 320, 456);
    }];
    
}




//brings detail view off screen
- (IBAction)backToTable:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        _historyDetailView.frame = CGRectMake(320, 63, 320, 456);
    }];
    
    self.clearButton.hidden = NO;
    self.clearButton.enabled = YES;
}




//save history entries array to memory
-(void)saveEntries
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedEntries = [NSKeyedArchiver archivedDataWithRootObject:self.entries];
    [userDefault setObject:encodedEntries forKey:@"entries"];
}




//clear history table
- (IBAction)clearHistory:(UIButton *)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"Clear History?"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Yes", nil];
    [message show];
}




//load history entries from memory
-(void)loadEntries
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *decodedEntries = [userDefault objectForKey:@"entries"];
    NSArray *test = [NSKeyedUnarchiver unarchiveObjectWithData:decodedEntries];
    if (test) {
        self.entries = [NSKeyedUnarchiver unarchiveObjectWithData:decodedEntries];
    }
}




//handles alertview selection
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.entries removeAllObjects];
        [self saveEntries];
        [self.historyTable reloadData];
    }
}
@end
