//
//  HomeViewController.h
//  AwayDay2012
//
//  Created by safadmoh on 11/09/13.
//
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "ContainerViewController.h"


@interface HomeViewController : ContainerViewController
<RNFrostedSidebarDelegate>

- (IBAction)onBurger:(id)sender;

@end
