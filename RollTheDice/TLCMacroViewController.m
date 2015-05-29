//
//  TLCMacroViewController.m
//  RollTheDice
//
//  Created by Thomas Caraway on 2/20/15.
//
//

#import "TLCMacroViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TLCMacro.h"
#import "TLCDiceRoll.h"
#import "TLCDiceRoller.h"
#import "TLCHistoryEntry.h"
#import "TLCHistoryViewController.h"

@interface TLCMacroViewController ()

@end

@implementation TLCMacroViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerData = @[@"d2",@"d3",@"d4",@"d6",@"d8",@"d10",@"d12",@"d20",@"d30",@"d100"];
    self.dicePicker.delegate = self;
    self.dicePicker.dataSource = self;
    self.createMacro.layer.cornerRadius = 8;
    self.addRollButton.layer.cornerRadius = 8;
    self.backButton.layer.cornerRadius = 8;
    self.total.layer.cornerRadius = 8;
    self.toRollButton.layer.cornerRadius = 8;
    self.toModButton.layer.cornerRadius = 8;
    self.backToNameButton.layer.cornerRadius = 8;
    self.backToRollButton.layer.cornerRadius = 8;
    self.rollSelectionButton.layer.cornerRadius = 8;
    self.macroTable.layer.cornerRadius = 8;
    [self loadMacros];
    [self.macroTable reloadData];
    
    self.macroNameField.delegate = self;
    
    //shadows for views
    CALayer *layer1 = self.rollView.layer;
    layer1.shadowOffset = CGSizeMake(1, 1);
    layer1.shadowColor = [[UIColor blackColor] CGColor];
    layer1.shadowRadius = 4.0f;
    layer1.shadowOpacity = 0.80f;
    layer1.shadowPath = [[UIBezierPath bezierPathWithRect:layer1.bounds] CGPath];
    
    CALayer *layer2 = self.modView.layer;
    layer2.shadowOffset = CGSizeMake(1, 1);
    layer2.shadowColor = [[UIColor blackColor] CGColor];
    layer2.shadowRadius = 4.0f;
    layer2.shadowOpacity = 0.80f;
    layer2.shadowPath = [[UIBezierPath bezierPathWithRect:layer2.bounds] CGPath];
    
    CALayer *layer3 = self.macroView.layer;
    layer3.shadowOffset = CGSizeMake(1, 1);
    layer3.shadowColor = [[UIColor blackColor] CGColor];
    layer3.shadowRadius = 4.0f;
    layer3.shadowOpacity = 0.80f;
    layer3.shadowPath = [[UIBezierPath bezierPathWithRect:layer3.bounds] CGPath];
    
    
    //adds done button to numpads
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.amountToRollField.inputAccessoryView = numberToolbar;
    self.modAmountField.inputAccessoryView = numberToolbar;
    
    //for swipe cell to left to delete
    self.macroTable.allowsMultipleSelectionDuringEditing = NO;
}




//for swipe cell to left to delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.macros removeObjectAtIndex:indexPath.row];
        [self.macroTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveMacros];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




//PICKER DELEGATE METHODS

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}




//touch anywhere else on screen to hide numberpad for textfields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}




//TABLE FUNCTIONS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.macros count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MacroEntry";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //puts macro name onto cell
    TLCMacro *cellMacro = [self.macros objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",cellMacro.name,cellMacro.macroFormula];
    return cell;
}




//rolls the selected macro in table
- (IBAction)rollMacro:(id)sender
{
    
    NSInteger selectedRow;
    NSIndexPath *selectedIndexPath = [self.macroTable indexPathForSelectedRow];
    
    //check if a row is selected
    if (!selectedIndexPath)
    {
        [self showAlertWithOption:1];
    }
    else
    {
        selectedRow = selectedIndexPath.row;
        TLCMacro *selectedMacro = [self.macros objectAtIndex:selectedRow];
        
        NSInteger total = 0;
        NSInteger j = [selectedMacro.diceToRoll count];
        //history entry individual rolls string
        NSString *macroHistoryEntryRolls = @"";
        
        for (int i=0; i<j; i++)
        {
            TLCDiceRoll *thisRoll = [selectedMacro.diceToRoll objectAtIndex:i];
            NSInteger thisRollValue = [thisRoll rollThis];
            
            if (i==0) {
                macroHistoryEntryRolls = thisRoll.individualRolls;
            }
            else
            {
            macroHistoryEntryRolls = [NSString stringWithFormat:@"%@\n%@",macroHistoryEntryRolls,thisRoll.individualRolls];
            }
            
            total = total + thisRollValue;
        }
    
        NSInteger modifier = selectedMacro.modifier;
        
        if (selectedMacro.isModified == 1)
        {
            if (selectedMacro.isAdded == 1)
            {
                total = total + modifier;
            }
            if (selectedMacro.isSubtracted == 1)
            {
                total = total - modifier;
            }
        }
        
        self.total.text = [@(total) stringValue];
        
        //ADDS HISTORY ENTRY TO TABLE
        TLCHistoryEntry *historyEntry = [[TLCHistoryEntry alloc] init];
        historyEntry.individualRolls = macroHistoryEntryRolls;
        historyEntry.formula = selectedMacro.macroFormula;
        historyEntry.total = [@(total) stringValue];
        
        TLCHistoryViewController *historyController = [self.tabBarController.childViewControllers objectAtIndex:2];
        [historyController.entries addObject:historyEntry];
        [historyController.historyTable reloadData];
        [historyController saveEntries];
    }
}




//brings the "name your macro" view onto screen
- (IBAction)showNewMacroView:(id)sender {
    [self animateDetailView];
    self.createButton.enabled = NO;
    self.createButton.hidden = YES;
}




//creates a macro object and puts on table, saves it in memory
- (IBAction)createMacro:(id)sender
{
    self.currentMacroBeingMade.isAdded = 0;
    self.currentMacroBeingMade.isSubtracted = 0;
    self.currentMacroBeingMade.isModified = 0;
    
    self.currentMacroBeingMade.macroFormula = self.macroFormula.text;
    
    if (![self.macroNameField hasText] || self.macroFormula.text.length == 0)
    {
        [self showAlertWithOption:2];
    }
    else
    {
    self.currentMacroBeingMade.name = self.macroNameField.text;
    NSInteger mod = [self.modAmountField.text integerValue];
    
    if ([self.modAmountField hasText])
    {
        self.currentMacroBeingMade.modifier = mod;
        self.currentMacroBeingMade.isModified = 1;
        
        if (self.modSelector.selectedSegmentIndex == 0)
        {
            self.currentMacroBeingMade.isAdded = 1;
            self.currentMacroBeingMade.macroFormula = [NSString stringWithFormat:@"%@ + %@",self.currentMacroBeingMade.macroFormula,self.modAmountField.text];
        }
        else if (self.modSelector.selectedSegmentIndex == 1)
        {
            self.currentMacroBeingMade.isSubtracted = 1;
            self.currentMacroBeingMade.macroFormula = [NSString stringWithFormat:@"%@ - %@",self.currentMacroBeingMade.macroFormula,self.modAmountField.text];
            
        }
    }
    
    //macro to be added to macro table
    TLCMacro *newMacro = self.currentMacroBeingMade;
    
    //reset fields in create-a-macro view
    self.macroFormula.text = @"";
    self.amountToRollField.text = @"";
    self.macroNameField.text = @"";
    self.modAmountField.text = @"";
    
    //reset currentMacroBeingMade
    self.currentMacroBeingMade = nil;
    
    //add new macro to table
    [self.macros addObject:newMacro];
    [self saveMacros];
    [self.macroTable reloadData];
    
    //return to table
    self.createButton.enabled = YES;
    self.createButton.hidden = NO;
    [self animateAllOff];
    }
    
}




//CHANGING BETWEEN CREATE-A-MACRO VIEWS**************************
//brings create-a-macro view into...view
-(void)animateDetailView
{
    [UIView animateWithDuration:0.5 animations:^{
        _macroView.frame = CGRectMake(0, 63, 320, 700);
    }];
    
    self.hasAddedModifier = false;
}

//return to macrotable view
- (void)backToTable
{
    [UIView animateWithDuration:0.5 animations:^{
        _macroView.frame = CGRectMake(320, 63, 320, 456);
    }];
    self.createButton.enabled = YES;
    self.createButton.hidden = NO;
}

//bring rollview onto screen
-(void)animateRollViewOn
{
    [UIView animateWithDuration:0.5 animations:^{
        _rollView.frame = CGRectMake(0, 63, 320, 456);
    }];
}
//bring rollview off screen
-(void)animateRollViewOff
{
    [UIView animateWithDuration:0.5 animations:^{
        _rollView.frame = CGRectMake(320, 63, 320, 456);
    }];
}

//bring modview onto screen
-(void)animateModViewOn
{
    [UIView animateWithDuration:0.5 animations:^{
        _modView.frame = CGRectMake(0, 63, 320, 456);
    }];
}

//bring modview off screen
-(void)animateModViewOff
{
    [UIView animateWithDuration:0.5 animations:^{
        _modView.frame = CGRectMake(320, 63, 320, 456);
    }];
}




//add a roll to the macro's formula
- (IBAction)addRoll:(UIButton *)sender
{
    if (![self.amountToRollField hasText]) {
        [self showAlertWithOption:3];
    }
    else
    {
    //initialize TLCMacro if it hasn't been already;
    if (!self.currentMacroBeingMade) {
        self.currentMacroBeingMade = [[TLCMacro alloc] init];
        self.currentMacroBeingMade.diceToRoll = [[NSMutableArray alloc] init];
        
    }
    
    NSString *amountToRollString = self.amountToRollField.text;
    NSInteger *amountToRollInt = [amountToRollString integerValue];
    
    NSInteger row = [self.dicePicker selectedRowInComponent:0];
    NSString *diceToRoll = [self.pickerData objectAtIndex:row];
    NSString *rollString;
    
    if ([self.macroFormula.text length] == 0) {
        rollString = [NSString stringWithFormat:@"%@%@",amountToRollString,diceToRoll];
    }
    else{
        rollString = [NSString stringWithFormat:@" + %@%@",amountToRollString,diceToRoll];
    }
    
    //change macroFormula's text to reflect new added roll
    self.macroFormula.text = [NSString stringWithFormat:@"%@%@",self.macroFormula.text,rollString];
    
    //change current macro's formula to reflect new added roll
    self.currentMacroBeingMade.macroFormula = self.macroFormula.text;
    
    //add this roll to macro's diceToRoll array
    TLCDiceRoll *roll = [[TLCDiceRoll alloc] init];
    roll.amountToRoll = amountToRollInt;
    roll.dieToRoll = diceToRoll;
    [self.currentMacroBeingMade.diceToRoll addObject:roll];
    }
}




//alerts
-(void)showAlertWithOption:(int)option
{
    if (option == 1)
    {
        //shows upon touch of "Roll Selected" if no macro is selected in table
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Must select macro first!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    else if (option == 2)
    {
        //shows upon touch of "Create Macro" if nothing has been entered into name field
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Macro requires a name and must contain at least one roll!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else if (option == 3)
    {
        //shows upon touch of "Add roll to formula" if no value in amountToRoll text field.
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Enter how many to roll before adding this to macro!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
}




//save macro array using nsuserdefaults
-(void)saveMacros
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *encodedMacros = [NSKeyedArchiver archivedDataWithRootObject:self.macros];
    [userDefault setObject:encodedMacros forKey:@"macros"];
}




//loads macro array from memory
-(void)loadMacros
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *decodedMacros = [userDefault objectForKey:@"macros"];
    NSArray *test = [NSKeyedUnarchiver unarchiveObjectWithData:decodedMacros];
    if (test) {
        self.macros = [NSKeyedUnarchiver unarchiveObjectWithData:decodedMacros];
    }
}




//FUNCTIONS FOR SWITCHING BETWEEN VIEWS
//returns to table from create-a-macro
- (IBAction)goBack:(UIButton *)sender
{
    [self backToTable];
    
    //reset fields in create-a-macro view
    self.macroFormula.text = @"";
    self.amountToRollField.text = @"";
    self.macroNameField.text = @"";
    self.modAmountField.text = @"";
    
    //reset currentMacroBeingMade
    self.currentMacroBeingMade = nil;
}

- (IBAction)toRollView:(UIButton *)sender
{
    [self animateRollViewOn];
}

- (IBAction)toModView:(UIButton *)sender
{
    [self animateModViewOn];
}

- (IBAction)backToNameView:(UIButton *)sender
{
    [self animateRollViewOff];
}

- (IBAction)backToRollView:(UIButton *)sender
{
    [self animateModViewOff];
}

-(void)animateAllOff
{
    [self animateModViewOff];
    [self animateRollViewOff];
    [self backToTable];
}




//FUNCTIONS FOR RESIGNING NUMPAD AND KEYPADS
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)doneWithNumberPad
{
    [self.modAmountField resignFirstResponder];
    [self.amountToRollField resignFirstResponder];
}
@end
