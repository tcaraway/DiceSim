//
//  TLCAppDelegate.h
//  RollTheDice
//
//  Created by Thomas Caraway on 9/3/14.
//
//

#import <UIKit/UIKit.h>
#import "TLCHistoryEntry.h"

@interface TLCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TLCHistoryEntry *entry;

@end
