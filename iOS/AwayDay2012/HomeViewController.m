//
//  HomeViewController.
//  AwayDay2012
//
//  Created by safadmoh on 11/09/13.
//
//

#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "RNFrostedSidebar.h"
#import "SpeakersViewController.h"
#import "CustomSlider.h"
static CGFloat const FVEDetailControllerTargetedViewTag = 111;

@interface HomeViewController () <RNFrostedSidebarDelegate>
{
    NSTimer *timer;
    CustomSlider *slider;
}

@property (nonatomic) UIView *flipView;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UILabel *infoLabel;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
    [self.counterTextLabel setFont:[UIFont fontWithName:@"Digitalism" size:40]];
    //     [self.minutesTextLabel setFont:[UIFont fontWithName:@"Digitalism" size:35]];
    //     [self.secondTextLabel setFont:[UIFont fontWithName:@"Digitalism" size:35]];
    //    [self.daysTextLabel setFont:[UIFont fontWithName:@"Digitalism" size:35]];
    
    
    //[self showDateCountdown];
    
}


-(void) updateCountdown
{
    
    NSString *dateString = @"27-09-2013";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    
    NSDateComponents *componentsHours = [calendar components:NSHourCalendarUnit fromDate:now];
    NSDateComponents *componentMint = [calendar components:NSMinuteCalendarUnit fromDate:now];
    NSDateComponents *componentSec = [calendar components:NSSecondCalendarUnit fromDate:now];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componentsDaysDiff = [gregorianCalendar components:NSDayCalendarUnit
                                                                fromDate:now
                                                                  toDate:dateFromString
                                                                 options:0];
    
    
    
    //  self.lblDaysSetting.text=[NSString stringWithFormat:@"%02d",componentsDaysDiff.day];
    //    self.hoursTextLabel.text=[NSString stringWithFormat:@"%02d",(24-componentsHours.hour)+componentsDaysDiff.day*24+12];
    //    self.minutesTextLabel.text=[NSString stringWithFormat:@"%02d",(60-componentMint.minute)];
    //    self.secondTextLabel.text=[NSString stringWithFormat:@"%02d",(60-componentSec.second)];
    
    
    //    self.daysTextLabel.text=[NSString stringWithFormat:@"%02dd",componentsDaysDiff.day];
    //    self.hoursTextLabel.text=[NSString stringWithFormat:@"%02dh",(24-componentsHours.hour)+12];
    //    self.minutesTextLabel.text=[NSString stringWithFormat:@"%02dm",(60-componentMint.minute)];
    //     self.secondTextLabel.text=[NSString stringWithFormat:@"%02ds",(60-componentSec.second)];
    
    
    self.counterTextLabel.text=[NSString stringWithFormat:@"%02dd:%02dh:%02dm:%02ds",componentsDaysDiff.day,(24-componentsHours.hour)+12,(60-componentMint.minute),(60-componentSec.second)];
    
    if(((24-componentsHours.hour)+componentsDaysDiff.day*24+12)==0)
    {
        [timer invalidate];
        self.counterTextLabel.hidden=YES;
//        self.hoursTextLabel.hidden=YES;
//        self.minutesTextLabel.hidden=YES;
//        self.secondTextLabel.hidden=YES;
    }
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if (!self.flipView)
    {
        return;
    }
    
    self.flipView.frame = CGRectMake(60, 380, 200, 200);//CGRectInset(self.view.bounds, 20, 20);
    //self.flipView.center = CGPointMake(floor(self.view.frame.size.width/2),
    //    floor((self.view.frame.size.height/2)*0.9));
}


-(IBAction)onBurger:(id)sender
{
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0:
        {
            [slider showHomeScreen];
            [sidebar dismiss];
        }
            break;
            
        case 1:
        {
            [slider showAgendaScreen];
            [sidebar dismiss];
            
        }
            break;
        case 2 :
        {
            [slider showSpeakersScreen];
            [sidebar dismiss];
            
        }
            break;
        case 3 :
        {
            [slider showMapScreen];
            [sidebar dismiss];
            
        }
            break;
        case 4 :
        {
            [slider showMyEventsScreen];
            [sidebar dismiss];
            
        }
            break;
        case 5 :
        {
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
            
        }
            break;
        case 6 :
        {
            [slider showVideoScreen];
            [sidebar dismiss];
            
        }
            break;
            
            
            
            
            
        default:
            break;
    }
    
}


- (void)viewDidUnload {
    [self setCounterTextLabel:nil];
    [super viewDidUnload];
}
@end
