//
//  CustomSlider.h
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import <Foundation/Foundation.h>
#import "RNFrostedSidebar.h"

@interface CustomSlider : NSObject


@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@property(nonatomic,strong)RNFrostedSidebar *callout;

-(void) showSliderMenu;

-(void)showTweetScreen;

-(void)showNotificationScreen;

-(void) showAgendaScreen;

-(void) showSpeakersScreen;

-(void) showMyEventsScreen;

-(void) showBreakOutSessionScreen;

-(void)showHomeScreen;

-(void)showGameInfoSCreen;


 
@end
