//
//  TLCHistoryEntry.m
//  RollTheDice
//
//  Created by Thomas Caraway on 2/25/15.
//
//

#import "TLCHistoryEntry.h"

@implementation TLCHistoryEntry


//DECODE
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.individualRolls = [aDecoder decodeObjectForKey:@"historyRolls"];
    self.total = [aDecoder decodeObjectForKey:@"historyTotal"];
    self.formula = [aDecoder decodeObjectForKey:@"historyFormula"];
    
    return self;
}



//ENCODE
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.individualRolls forKey:@"historyRolls"];
    [aCoder encodeObject:self.total forKey:@"historyTotal"];
    [aCoder encodeObject:self.formula forKey:@"historyFormula"];
}
@end
