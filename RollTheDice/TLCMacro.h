//
//  TLCMacro.h
//  RollTheDice
//
//  Created by Thomas Caraway on 3/14/15.
//
//

#import <Foundation/Foundation.h>

@interface TLCMacro : NSObject <NSCoding>

//true if modifier is added or subtracted
@property NSInteger isModified;

//true if a modifier is added
@property NSInteger isAdded;

//true if a modifier is subtracted
@property NSInteger isSubtracted;

//number to be added/subtracted
@property NSInteger modifier;

@property (strong, nonatomic) NSString *name;
@property NSString *macroFormula;
@property (strong, nonatomic) NSMutableArray *diceToRoll;


@end
