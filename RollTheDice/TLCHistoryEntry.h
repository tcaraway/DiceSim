//
//  TLCHistoryEntry.h
//  RollTheDice
//
//  Created by Thomas Caraway on 2/25/15.
//
//

#import <Foundation/Foundation.h>

@interface TLCHistoryEntry : NSObject <NSCoding>

@property (strong, nonatomic) NSString *individualRolls;
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSString *formula;

@end
