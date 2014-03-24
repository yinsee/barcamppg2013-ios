//
//  QRScannerViewController.m
//  BarCampPenang
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "QRScannerViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface QRScannerViewController ()
@property (nonatomic, retain) ZXCapture* capture;
- (NSString*)displayForResult:(ZXResult*)result;
@end

@implementation QRScannerViewController

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
	// Do any additional setup after loading the view.
    self.screenName = @"QR Scanner";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.capture = [[ZXCapture alloc] init];
//    self.capture.rotation = 90.0f;
    // Use the back camera
    self.capture.camera = self.capture.back;
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    for (UIView *view in self.view.subviews) {
        [self.view bringSubviewToFront:view];
    }
    // seems to be faster if we set delegate at the end
    self.capture.delegate = self;
}

- (IBAction)cancel:(id)sender {
    self.capture.delegate = nil;
    [self.capture stop];
    [self.capture.layer removeFromSuperlayer];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//#pragma mark - Private Methods
//
//- (NSString*)displayForResult:(ZXResult*)result {
//    NSString *formatString;
//    switch (result.barcodeFormat) {
//        case kBarcodeFormatAztec:
//            formatString = @"Aztec";
//            break;
//            
//        case kBarcodeFormatCodabar:
//            formatString = @"CODABAR";
//            break;
//            
//        case kBarcodeFormatCode39:
//            formatString = @"Code 39";
//            break;
//            
//        case kBarcodeFormatCode93:
//            formatString = @"Code 93";
//            break;
//            
//        case kBarcodeFormatCode128:
//            formatString = @"Code 128";
//            break;
//            
//        case kBarcodeFormatDataMatrix:
//            formatString = @"Data Matrix";
//            break;
//            
//        case kBarcodeFormatEan8:
//            formatString = @"EAN-8";
//            break;
//            
//        case kBarcodeFormatEan13:
//            formatString = @"EAN-13";
//            break;
//            
//        case kBarcodeFormatITF:
//            formatString = @"ITF";
//            break;
//            
//        case kBarcodeFormatPDF417:
//            formatString = @"PDF417";
//            break;
//            
//        case kBarcodeFormatQRCode:
//            formatString = @"QR Code";
//            break;
//            
//        case kBarcodeFormatRSS14:
//            formatString = @"RSS 14";
//            break;
//            
//        case kBarcodeFormatRSSExpanded:
//            formatString = @"RSS Expanded";
//            break;
//            
//        case kBarcodeFormatUPCA:
//            formatString = @"UPCA";
//            break;
//            
//        case kBarcodeFormatUPCE:
//            formatString = @"UPCE";
//            break;
//            
//        case kBarcodeFormatUPCEANExtension:
//            formatString = @"UPC/EAN extension";
//            break;
//            
//        default:
//            formatString = @"Unknown";
//            break;
//    }
//    
//    return [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
//}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result && result.barcodeFormat==kBarcodeFormatQRCode) {

        // stop to prevent multiple trigger
        [self.capture stop];
        
        // We got a result. Display information about the result onscreen.
        //[self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:[self displayForResult:result] waitUntilDone:YES];
        
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        NSArray *data = [result.text componentsSeparatedByString:kQRCodeDelimiter];
        if ([data count]!=kQRCodeNumberOfItems)
        {
            // do nothing
            [self.capture start];
        }
        else
        {
            // play camera shutter sound
            AudioServicesPlaySystemSound(1108);

//            [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"QRScanner" withAction:@"Scanned" withLabel:@"" withValue:nil];
            
            // post the notification
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifQRCodeSuccess object:nil userInfo:[NSDictionary dictionaryWithObject:data forKey:@"data"]];
            [self cancel:nil];
        }
        
    }
}
@end
