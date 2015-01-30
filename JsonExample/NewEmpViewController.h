//
//  NewEmpViewController.h
//  JsonExample
//
//  Created by Sesha Sai Bhargav Bandla on 1/30/15.
//  Copyright (c) 2015 Sesha Sai Bhargav Bandla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEmpViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmpId;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstNmae;
@property (weak, nonatomic) IBOutlet UITextField *txtDesignation;
@property (weak, nonatomic) IBOutlet UITextField *txtSalary;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneno;

@end
