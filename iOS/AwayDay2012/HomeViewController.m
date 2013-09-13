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
#import "SpeakersViewController.h"
static CGFloat const FVEDetailControllerTargetedViewTag = 111;

@interface HomeViewController ()
{
    NSTimer *timer;
}
@property(nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic) UIView *flipView;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UILabel *infoLabel;


@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

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
    self.optionIndices = [[NSMutableIndexSet alloc]init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    

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
        self.hoursTextLabel.hidden=YES;
        self.minutesTextLabel.hidden=YES;
        self.secondTextLabel.hidden=YES;
    }
    
    
    
}


- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    return theLocation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onBurger:(id)sender {
    
       NSArray *images = @[
                        [UIImage imageNamed:@"agenda"],
                        [UIImage imageNamed:@"speaker_icon"],
                        [UIImage imageNamed:@"map"],
                        [UIImage imageNamed:@"my_schedule"],
                        
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    //    callout.showFromRight = YES;
    [callout show];
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %i",index);
    
    if(index==0)
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:[[AgendaViewController alloc]initWithNibName:@"RootViewController" bundle:nil ]] animated:YES];
        [sidebar dismiss];

        
    }

    else if(index==1)
    {
        UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SpeakersViewController *speakerViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"speakersViewIdentifier"];
        [self.navigationController pushViewController:speakerViewController animated:YES];
        
        
        
        [sidebar dismiss];
    }
    else if(index==2)
    {
           NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude, 12.969034,77.745137];
        
            NSString *escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
            NSURL *url=[NSURL URLWithString:escapedString];
            [[UIApplication sharedApplication]openURL:url];

        
    }
    else if(index==3)
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.userPathViewController] animated:YES];
        [sidebar dismiss];
    }

    



}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}

   

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];

    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if (!self.flipView) {
        return;
    }
    
    self.flipView.frame = CGRectMake(60, 380, 200, 200);//CGRectInset(self.view.bounds, 20, 20);
    //self.flipView.center = CGPointMake(floor(self.view.frame.size.width/2),
    //    floor((self.view.frame.size.height/2)*0.9));
}



@end
