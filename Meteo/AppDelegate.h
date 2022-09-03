//
//  AppDelegate.h
//  Meteo
//
//  Created by Gabriele Ranzieri on 03/09/2019.
//  Copyright © 2019 Gabriele Ranzieri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

