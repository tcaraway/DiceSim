//
//  TLCViewController.h
//  RollTheDice
//
//  Created by Thomas Caraway on 9/3/14.
//
//

#import <UIKit/UIKit.h>
#import "TLCDiceRoller.h"
#import "TLCHistoryViewController.h"
#import "TLCMacroViewController.h"
#import "TLCAppDelegate.h"

@interface TLCRollerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *backView;


//buttons
- (IBAction)rollDice:(UIButton *)sender;

//object used to simulate rolling
@property (strong, nonatomic) TLCDiceRoller* diceRoller;

//more UI
@property (strong, nonatomic) IBOutlet UITextField *amountOfDiceToRoll;
@property (strong, nonatomic) IBOutlet UILabel *valueOfRoll;

- (void)updateValuesToTotal:(NSInteger)total;
- (void)showAmountAlertWithOption:(int)option;

//picker data array
@property NSArray *pickerData;

@property (strong, nonatomic) IBOutlet UIPickerView *dicePicker;
@property (strong, nonatomic) IBOutlet UIButton *rollButton;


@end
