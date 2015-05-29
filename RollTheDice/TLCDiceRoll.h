//
//  TLCDiceRoll.h
//  RollTheDice
//
//  Created by Thomas Caraway on 3/17/15.
//
//

#import <Foundation/Foundation.h>


//represents a roll (for example: 2d6) used in macros
@interface TLCDiceRoll : NSObject <NSCoding>

@property NSInteger amountToRoll;
@property (strong, nonatomic) NSString *dieToRoll;
@property (strong, nonatomic) NSString *individualRolls;

-(NSInteger)rollThis;

@end
