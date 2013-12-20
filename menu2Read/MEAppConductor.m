//
//  MEAppConductor.m
//  menu2Read
//
//  Created by Olivier Delecueillerie on 13/12/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "MEAppConductor.h"
#import "SYSyncEngine.h"
#import "Drink.h"
#import "CategoryDrink.h"
#import "SquareMenuAd.h"

@interface MEAppConductor()

@end

@implementation MEAppConductor

-(void) register2Sync {
    [[SYSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Drink class]];
    [[SYSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[CategoryDrink class]];
    [[SYSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[SquareMenuAd class]];
}

-(void) start2Sync {
    [[SYSyncEngine sharedEngine] startSync];
}
@end
