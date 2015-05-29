//
//  TLCMacroViewController.h
//  RollTheDice
//
//  Created by Thomas Caraway on 2/20/15.
//
//

#import <UIKit/UIKit.h>
#import "TLCMacro.h"

@interface TLCMacroViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

//UI
@property (strong, nonatomic) IBOutlet UILabel *total;
@property (strong, nonatomic) IBOutlet UITableView *macroTable;
- (IBAction)rollMacro:(id)sender;
- (IBAction)showNewMacroView:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *rollSelectionButton;
@property (strong, nonatomic) IBOutlet UIButton *createButton;

//views for creating new macro
//first view : NAME
@property (strong, nonatomic) IBOutlet UIView *macroView;
//second view : ROLLS
@property (strong, nonatomic) IBOutlet UIView *rollView;
//third view : MODIFIER
@property (strong, nonatomic) IBOutlet UIView *modView;
- (IBAction)toRollView:(UIButton *)sender;
- (IBAction)toModView:(UIButton *)sender;
- (IBAction)backToNameView:(UIButton *)sender;
- (IBAction)backToRollView:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *macroNameField;
- (IBAction)createMacro:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *macroFormula;
@property (strong, nonatomic) IBOutlet UIPickerView *dicePicker;
@property (strong, nonatomic) IBOutlet UITextField *amountToRollField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *modSelector;
@property (strong, nonatomic) IBOutlet UITextField *modAmountField;
@property (strong, nonatomic) IBOutlet UIButton *createMacro;
@property (strong, nonatomic) IBOutlet UIButton *addRollButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)goBack:(UIButton *)sender;

//array for populating table / holding macros
@property (strong, nonatomic) NSMutableArray *macros;

//picker data array
@property NSArray *pickerData;

//add new roll to macro
- (IBAction)addRoll:(UIButton *)sender;

@property (strong,nonatomic) TLCMacro *currentMacroBeingMade;

//used in updating macroFormula field text dynamically
@property BOOL hasAddedModifier;

//shows alerts
-(void)showAlertWithOption:(int)option;

//save and load macro array
-(void)saveMacros;
-(void)loadMacros;
@property (strong, nonatomic) IBOutlet UIButton *toRollButton;
@property (strong, nonatomic) IBOutlet UIButton *backToRollButton;
@property (strong, nonatomic) IBOutlet UIButton *toModButton;
@property (strong, nonatomic) IBOutlet UIButton *backToNameButton;

@end
