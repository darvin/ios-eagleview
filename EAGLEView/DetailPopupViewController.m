//
//  DetailPopupViewController.m
//  EAGLEView
//
//  Created by Jens Willy Johannsen on 25/01/14.
//  Copyright (c) 2014 Greener Pastures. All rights reserved.
//

#import "DetailPopupViewController.h"
#import "EAGLEPart.h"
#import "EAGLEPackage.h"
#import "EAGLESchematic.h"
#import "EAGLEInstanceView.h"

static const CGFloat kSettingsGrayAlpha = 0.2;	// Alpha of gray overlay view
static const CGFloat kSettingsAnimationDuration = 0.3;	// Alpha of gray overlay view

@interface DetailPopupViewController ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet EAGLEInstanceView *instanceView;
@property (weak, nonatomic) IBOutlet UILabel *libraryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTitleLabel;	// So we can show either "Device" or "Package"
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation DetailPopupViewController
{
	__weak UIViewController *_parentViewController;
	__weak UIView *_grayView;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	// iPhone or iPad?
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		// iPad: remove OK button. The preferred content size is set as a runtime attribute in the storyboard file.
		[self.okBtn removeFromSuperview];
	}
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscape;
}

- (void)showAddedToViewController:(UIViewController*)parentViewController
{
	// Remember parent view controller
	_parentViewController = parentViewController;

	// Move self to parent view controller
	self.view.frame = parentViewController.view.bounds;	// Adjust own frame to match parent view controller's
	[parentViewController addChildViewController:self];
	[self didMoveToParentViewController:parentViewController];
	[parentViewController.view addSubview:self.view];

	// Add gray view below own view
	UIView *grayView = [[UIView alloc] initWithFrame:self.view.bounds];
	grayView.backgroundColor = [UIColor blackColor];
	grayView.alpha = 0;
	[parentViewController.view insertSubview:grayView belowSubview:self.view];
	_grayView = grayView;

	// Add round corners
	self.view.layer.cornerRadius = 8;
	self.view.alpha = 0;

	// Constraints to set fixed size and centered X and Y to superview
	// The size is taken from the property size. This can be set in IB by using a "User Defined Runtime Attribute" named "size"
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = @{ @"self": self.view };
	NSDictionary *metrics = @{ @"width": @( self.size.width ), @"height": @( self.size.height ) };
	[parentViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(width)]" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
	[parentViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];

	// Fade in views
	[UIView animateWithDuration:kSettingsAnimationDuration animations:^{
		self.view.alpha = 1;
		_grayView.alpha = kSettingsGrayAlpha;
	}];
}

- (void)dismiss
{
	// Note: this happens only on iPhone. On iPad, this view controller is presented as in a popover and the OK button is removed.
	[UIView animateWithDuration:kSettingsAnimationDuration animations:^{

		// Fade out views
		_grayView.alpha = 0;
		self.view.alpha = 0;

	} completion:^(BOOL finished) {

		// Remove the gray view
		[_grayView removeFromSuperview];

		// Remove self
		[self willMoveToParentViewController:nil];
		[self.view removeFromSuperview];
		[self removeFromParentViewController];
	}];
}

- (void)setInstance:(EAGLEInstance *)instance
{
	// Make sure the view and IBOutlets are loaded
	[self view];

	self.typeLabel.text = [NSString stringWithFormat:@"%@ – %@", instance.part_name, [instance valueText]];
	self.nameLabel.text = instance.part_name;
	self.valueLabel.text = [instance valueText];

	// Get part
	EAGLEPart *part = [instance.schematic partWithName:instance.part_name];
	self.libraryLabel.text = part.library_name;
	
	NSString *deviceString;
	if( [part.device_name length] > 0 )
		deviceString = [NSString stringWithFormat:@"%@\r(%@)", part.deviceset_name, part.device_name];
	else
		deviceString = part.deviceset_name;
	self.deviceLabel.text = deviceString;

	self.deviceTitleLabel.text = @"Device";
}

- (void)setElement:(EAGLEElement *)element
{
	// Make sure the view and IBOutlets are loaded
	[self view];

	self.typeLabel.text = [NSString stringWithFormat:@"%@ – %@", element.name, element.value];
	self.nameLabel.text = element.name;
	self.valueLabel.text = element.value;
	self.libraryLabel.text = element.library_name;

	EAGLEPackage *package = element.package;
	self.deviceLabel.text = package.name;

	self.deviceTitleLabel.text = @"Package";
}

- (void)setModuleInstance:(EAGLEDrawableModuleInstance *)moduleInstance
{
	// Make sure the view and IBOutlets are loaded
	[self view];

	self.typeLabel.text = @"Module";
	self.nameLabel.text = moduleInstance.name;
	self.valueLabel.text = @"…";
	self.libraryLabel.text = @"…";
	self.deviceLabel.text = nil;
	self.deviceTitleLabel.text = nil;
}

@end
