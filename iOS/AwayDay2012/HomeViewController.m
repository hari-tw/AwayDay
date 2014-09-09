

#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "CFShareCircleView.h"
#import "RNFrostedSidebar.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SpeakersViewController.h"
#import "CustomSlider.h"
static CGFloat const FVEDetailControllerTargetedViewTag = 111;
bool blinkStatus = NO;
@interface HomeViewController () <RNFrostedSidebarDelegate,CFShareCircleViewDelegate>
{
    NSTimer *timer;
    CustomSlider *slider;
}

@property (nonatomic) UIView *flipView;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UILabel *infoLabel;
@property (nonatomic, strong) CFShareCircleView *shareCircleView;

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
    
    
}


-(void) updateCountdown
{
    
    NSString *dateString = @"2013-09-27 15:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    
    dateFromString = [dateFormatter dateFromString:dateString];

//
//    
   NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    
//    
//    NSDateComponents *componentsHours = [calendar components:NSHourCalendarUnit fromDate:now];
//    NSDateComponents *componentMint = [calendar components:NSMinuteCalendarUnit fromDate:now];
//    NSDateComponents *componentSec = [calendar components:NSSecondCalendarUnit fromDate:now];
//    
//    
//  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *componentsDaysDiff = [gregorianCalendar components:NSDayCalendarUnit
//                                                                fromDate:now
//                                                                  toDate:dateFromString
//                                                                 options:0];
    
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit| NSSecondCalendarUnit;
    
    NSDateComponents *conversionInfo = [calendar components:unitFlags fromDate:now  toDate:dateFromString  options:0];
    
    //int months = [conversionInfo month];
    int days = [conversionInfo day];
    int hours = [conversionInfo hour];
    int minutes = [conversionInfo minute];
    int seconds=[conversionInfo second];
    
    
       
    NSLog(@"%@",[NSString stringWithFormat:@"%dd:%dh:%dm:%ds",days,hours,minutes,seconds]);
   self.counterTextLabel.text=[NSString stringWithFormat:@"%dd:%dh:%dm:%ds",days,hours,minutes,seconds];
    
    
    NSComparisonResult result = [now compare:dateFromString];
    if (result == NSOrderedAscending) {
        
    } else if (result == NSOrderedDescending) {
       // [timer invalidate];
        [self blink];
        self.counterTextLabel.text=@"Started";
        
    }  else {
        //[timer invalidate];
        [self blink];
        self.counterTextLabel.hidden=@"Started";
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
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown)userInfo:nil repeats: YES];
    
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

-(void)blink{
    self.counterTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    if(blinkStatus == NO){
        self.counterTextLabel.textColor = [UIColor blackColor];
        
        blinkStatus = YES;
    }else {
        self.counterTextLabel.textColor = [UIColor grayColor];
        blinkStatus = NO;
    }
}

-(IBAction)onBurger:(id)sender
{
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

#pragma mark -RNFrostedSidebar delegate method.
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
            [slider showBreakOutSessionScreen];
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
            [slider showNotificationScreen];
            [sidebar dismiss];
            
            
        }
            break;
//        case 6 :
//        {
//            [slider showNotificationScreen];
//            [sidebar dismiss];
//
//        }
//            break;
        case 7:
        {
            [sidebar dismiss];
             [slider showGameInfoSCreen];
            // Do any additional setup after loading the view, typically from a nib.
//            self.shareCircleView = [[CFShareCircleView alloc] init];
//            self.shareCircleView.delegate = self;
//            [self.shareCircleView show];
            
        }
            break;
            
            
            
            
            
        default:
            break;
    }
    
}

- (void)shareCircleView:(CFShareCircleView *)shareCircleView didSelectSharer:(CFSharer *)sharer
{
    NSLog(@"Selected sharer: %@", sharer.name);
    if([sharer.name isEqualToString:@"Twitter"])
        [self postOnTWitterWall];
    else
        [self postOnFacebookWall];
    
}

- (void)shareCircleCanceled:(NSNotification *)notification{
    NSLog(@"Share circle view was canceled.");
}



-(void)postOnFacebookWall
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        NSString *shareText = @"Thoughtworks Away Day-2013!";
        [mySLComposerSheet setInitialText:shareText];
        
        //        [mySLComposerSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50.jpg"]]]];
        
        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];
        
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    
}

-(void)postOnTWitterWall
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        NSString *shareText = @"Thoughtworks Away Day-2013 (27 & 28th September)! ";
        [mySLComposerSheet setInitialText:shareText];
        
        [mySLComposerSheet addImage:[UIImage imageNamed:@"home-page-new.png"]];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://thoughtworks.com"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    
    
}


- (void)viewDidUnload {
    [self setCounterTextLabel:nil];
    [super viewDidUnload];
}
@end
