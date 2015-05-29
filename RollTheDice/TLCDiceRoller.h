//
//  TLCDiceRoller.h
//  RollTheDice
//
//  Created by Thomas Caraway on 9/3/14.
//
//

#import <Foundation/Foundation.h>
#import "TLCHistoryEntry.h"
#import "TLCMacro.h"

@interface TLCDiceRoller : NSObject

@property (strong, nonatomic) TLCHistoryEntry* historyEntry;

-(NSInteger)rollDiceWithSides:(NSInteger)sides thisManyTimes:(NSInteger)toRoll;
+(NSInteger)getSidesOfDie:(NSString*)sides;
+(NSString*)createStringWith:(NSString*)amountRolled WithDie:(NSString*)dieName AndValue:(NSString*)valueRolled;
+(NSInteger)rollWithoutHistoryWithSides:(NSInteger)sides thisManyTimes:(NSInteger)toRoll;



@end
