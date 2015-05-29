//
//  TLCDiceRoller.m
//  RollTheDice
//
//  Created by Thomas Caraway on 9/3/14.
//
//

#import "TLCDiceRoller.h"
#import "TLCDiceRoll.h"

@implementation TLCDiceRoller


-(NSInteger)rollDiceWithSides:(NSInteger)sides thisManyTimes:(NSInteger)toRoll
{
    NSString* individualRolls = @"";
    NSInteger total = 0;
    
    //"rolls" die required amount of times
    for (int i=0; i<toRoll; i++) {
        int rolled = arc4random_uniform(sides) + 1;
        total = total + rolled;
         NSString* rollString;
        
        if (i == toRoll - 1)
            rollString = [NSString stringWithFormat:@"%i", rolled];
        else
            rollString = [NSString stringWithFormat:@"%i,  ", rolled];
        
        individualRolls = [NSString stringWithFormat:@"%@%@",individualRolls,rollString];
    }
    
    //creates rollHistory entry
    self.historyEntry = [[TLCHistoryEntry alloc] init];
    self.historyEntry.total = [@(total) stringValue];
    NSString *amountRolled = [@(toRoll) stringValue];
    NSString *sidedDie = [@(sides) stringValue];
    self.historyEntry.formula = [NSString stringWithFormat:@"%@d%@",amountRolled,sidedDie];
    self.historyEntry.individualRolls = individualRolls;
    
    return total;
}




//rolls without creating a historyEntry
+(NSInteger)rollWithoutHistoryWithSides:(NSInteger)sides thisManyTimes:(NSInteger)toRoll
{
    NSInteger total = 0;
    
    //"rolls" die required amount of times
    for (int i=0; i<toRoll; i++) {
        int rolled = arc4random_uniform(sides) + 1;
        total = total + rolled;
    }
    
    return total;
}




//gets sides of a die (int) given a string
+(NSInteger)getSidesOfDie:(NSString*)sides
{
    return [[sides substringFromIndex:1] integerValue];
    
}




//OLD, NOT NEEDED?
+(NSString*)createStringWith:(NSString *)amountRolled WithDie:(NSString *)dieName AndValue:(NSString *)valueRolled
{
    NSString* str1 = [NSString stringWithFormat:@"%@%@",amountRolled,dieName];
    NSString* str2;
   
    if (str1.length == 3)
    {
        str2 = [NSString stringWithFormat:@"%@                     %@\n",str1,valueRolled];
    }
    else if (str1.length ==4)
    {
        str2 = [NSString stringWithFormat:@"%@                   %@\n",str1,valueRolled];
    }
    else if (str1.length == 5)
    {
        str2 = [NSString stringWithFormat:@"%@                 %@\n",str1,valueRolled];
    }
    else if (str1.length == 6)
    {
        str2 = [NSString stringWithFormat:@"%@               %@\n",str1,valueRolled];
    }
    else if (str1.length == 7)
    {
        str2 = [NSString stringWithFormat:@"%@             %@\n",str1,valueRolled];
    }
        return str2;
}

@end
