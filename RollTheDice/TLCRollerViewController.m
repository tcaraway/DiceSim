//
//  TLCViewController.m
//  RollTheDice
//
//  Created by Thomas Caraway on 9/3/14.
//
//

#import "TLCRollerViewController.h"
#import "TLCDiceRoller.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <iAd/iAd.h>


@interface TLCRollerViewController ()

@end

@implementation TLCRollerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.amountOfDiceToRoll.text = @"";
    
    //rounds corners for UI elements
    self.rollButton.layer.cornerRadius = 8;
    self.valueOfRoll.layer.cornerRadius = 8;
    self.dicePicker.layer.cornerRadius = 8;
    self.backView.layer.cornerRadius = 8;
    
    //initialize data for picker etc.
    self.pickerData = @[@"d2",@"d3",@"d4",@"d6",@"d8",@"d10",@"d12",@"d20",@"d30",@"d100"];
    self.dicePicker.dataSource = self;
    self.dicePicker.delegate = self;
        
    self.amountOfDiceToRoll.clearsOnBeginEditing = true;
    
    [self.valueOfRoll setAdjustsFontSizeToFitWidth:YES];
    
    //initialize history controller's array
    TLCHistoryViewController *historyController = [self.tabBarController.childViewControllers objectAtIndex:2];
    historyController.entries = [[NSMutableArray alloc] init];
    
    //initializes macro controller's array
    TLCMacroViewController *macroController = [self.tabBarController.childViewControllers objectAtIndex:1];
    macroController.macros = [[NSMutableArray alloc] init];
    
    //adds done button to numpads
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.amountOfDiceToRoll.inputAccessoryView = numberToolbar;
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




//updates the total label
-(void)updateValuesToTotal:(NSInteger)total
{
    self.valueOfRoll.text = [NSString stringWithFormat: @"%d", (int)total];
}




//show alerts
-(void)showAmountAlertWithOption:(int)option
{
    if (option == 1)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Too many dice! Must be < 1000"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [message show];
    }
    else if (option == 2)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Wait!"
                                                    message:@"Enter amount of dice to roll before selecting a die."
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        
        [message show];
    }
    else if (option ==3)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"How to use:"
                                                    message:@"Enter the amount of dice to roll, choose your die, and roll!."
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        
        [message show];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Modifier muse be < 1000"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        
        [message show];
    }
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




//resigns numpad
-(void)doneWithNumberPad
{
    [self.amountOfDiceToRoll resignFirstResponder];
}




//rolls the dice!
- (IBAction)rollDice:(UIButton *)sender
{
    [self.amountOfDiceToRoll resignFirstResponder];
    self.diceRoller = [[TLCDiceRoller alloc] init];
    NSInteger amount = [self.amountOfDiceToRoll.text integerValue];
    
    if ([self.amountOfDiceToRoll.text isEqualToString:@""])
    {
        [self showAmountAlertWithOption:2];
    }
    else if (amount > 999)
    {
        [self showAmountAlertWithOption:1];
    }
    else
    {
        NSInteger row = [self.dicePicker selectedRowInComponent:0];
        NSString *diceToRoll = [self.pickerData objectAtIndex:row];
        NSInteger sides = [TLCDiceRoller getSidesOfDie:diceToRoll];
        NSInteger total = [self.diceRoller rollDiceWithSides:sides thisManyTimes:amount];
        
        self.diceRoller.historyEntry.total = [@(total) stringValue];
        [self updateValuesToTotal:total];
        
        //GIVES HISTORY ENTRY TO HistoryViewController
        TLCHistoryEntry *historyEntry = self.diceRoller.historyEntry;
        TLCHistoryViewController *historyController = [self.tabBarController.childViewControllers objectAtIndex:2];
        [historyController.entries addObject:historyEntry];
        [historyController.historyTable reloadData];
        
        [historyController saveEntries];
    }
}
@end
