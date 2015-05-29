//
//  TLCDiceRoll.m
//  RollTheDice
//
//  Created by Thomas Caraway on 3/17/15.
//
//

#import "TLCDiceRoll.h"

@implementation TLCDiceRoll



-(NSInteger)rollThis
{
    NSInteger total = 0;
    NSInteger sidesOfDie =[[self.dieToRoll substringFromIndex:1] integerValue];
    self.individualRolls = [NSString stringWithFormat:@"%i%@ : ",self.amountToRoll,self.dieToRoll];
    
    //"rolls" die required amount of times
    for (int i=0; i<self.amountToRoll; i++)
    {
        int rolled = arc4random_uniform(sidesOfDie) + 1;
        NSString* singleRoll;
        if (i == self.amountToRoll - 1)
        {
            singleRoll = [NSString stringWithFormat:@"%i", rolled];
        }
        else
        {
            singleRoll = [NSString stringWithFormat:@"%i, ",rolled];
        }
        self.individualRolls = [NSString stringWithFormat:@"%@%@",self.individualRolls,singleRoll];
        total = total + rolled;
    }
    
    return total;
}




//DECODE
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSNumber *amount = [aDecoder decodeObjectForKey:@"amountToRoll"];
    self.amountToRoll = [amount integerValue];
    self.dieToRoll = [aDecoder decodeObjectForKey:@"dieToRoll"];
    self.individualRolls = [aDecoder decodeObjectForKey:@"individualRolls"];
    
    return self;
}




//ENCODE
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSNumber *amount = [NSNumber numberWithInteger:self.amountToRoll];
    [aCoder encodeObject:amount forKey:@"amountToRoll"];
    [aCoder encodeObject:self.dieToRoll forKey:@"dieToRoll"];
    [aCoder encodeObject:self.individualRolls forKey:@"individualRolls"];
    
}

@end
