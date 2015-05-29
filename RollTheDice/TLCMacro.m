//
//  TLCMacro.m
//  RollTheDice
//
//  Created by Thomas Caraway on 3/14/15.
//
//

#import "TLCMacro.h"

@implementation TLCMacro




//ENCODE
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.isModified) forKey:@"isModified"];
    [aCoder encodeObject:@(self.isAdded) forKey:@"isAdded"];
    [aCoder encodeObject:@(self.isSubtracted) forKey:@"isSubtracted"];
    //NSNumber *mod = [NSNumber numberWithInteger:self.modifier];
    [aCoder encodeObject:@(self.modifier) forKey:@"modifier"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.macroFormula forKey:@"macroFormula"];
    [aCoder encodeObject:self.diceToRoll forKey:@"diceToRoll"];
}




//DECODE
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSNumber *add = [aDecoder decodeObjectForKey:@"isAdded"];
    NSNumber *isMod = [aDecoder decodeObjectForKey:@"isModified"];
    NSNumber *sub = [aDecoder decodeObjectForKey:@"isSubstracted"];
    self.isModified = [isMod integerValue];
    self.isAdded = [add integerValue];
    self.isSubtracted = [sub integerValue];
    
    NSNumber *mod = [aDecoder decodeObjectForKey:@"modifier"];
    self.modifier = [mod integerValue];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.macroFormula = [aDecoder decodeObjectForKey:@"macroFormula"];
    self.diceToRoll = [aDecoder decodeObjectForKey:@"diceToRoll"];
    
    return self;
}
@end
