//
//  Constants.swift
//  photoframe
//
//  Created by Bhavi Tech on 25/11/21.
//

import Foundation

struct Constants
{
    struct API
    {
        static let BASEURL = "http://techeruditedev.xyz/projects/photo-frame-api/api/"
        
        // Login URL
        static var loginURL: String
        {
            return BASEURL + "user/login"
        }
        
        static var codeURL: String
        {
            return BASEURL + "user/login_with_code"
        }
        // Register URL
        static var RegisterURL: String
        {
            return BASEURL + "user/register"
        }
        
        // OTPURL
        static var verification: String
        {
            return BASEURL + "user/email_verification"
        }
        
        //ForgotpasswordURL
        static var forgot: String
        {
            return BASEURL + "user/send_forgot_password_code"
        }
        
        // Newpassword URL
        static var newpassword: String
        {
            return BASEURL + "user/set_new_password"
        }
        
        // Newpassword URL
        static var confirmotp: String
        {
            return BASEURL + "user/verify_forgot_password_code"
        }
        
    }
    struct SESSION
    {
        static let Deviceid = "deviceid"
        static let USERID = "USERID"
        static let token = "token"
        static let emailid = "emailid"
        static let remembermeemail = "remembermeemail"
        static let hasvalue = "hasvalue"
    }
    
    struct Alerts
       {
           static let validEmail = "Email address invalid. Please provide valid email address"
           static let validPassword = "Your password must contain at least one lower case, one upper case and a number. The password must be between 8 characters and 30 characters."
       }
    
    
    
    struct MESSAGE_DESCRIPTION
    {
        static let NO_INTERNET_CONNECTION = "No internet connection"
        
    }
    
}
