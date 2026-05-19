//
//  ValidationController.swift
//  Capsula
//
//  Created by admin on 23/12/20.
//

import Foundation


final class ValidationController {
    static let shared = ValidationController()
    ///CreateAccount
    static func validate(fname: String,lname: String, email: String,country:String,password : String, ConfPassword:String,dob: String) -> String? {
        
        if let invalidFName = ValidationController.validateFName(fname: fname){
           return invalidFName
        }
        else if let invalidLName = ValidationController.validateLName(lname: lname){
            return invalidLName
        }
        else if let invalidEmail = ValidationController.validateEmail(email: email){
            return invalidEmail
        }
        else if let invalidCountry = ValidationController.validateForCountry(country: country){
            return invalidCountry
        }
        else if let invalidPassword = ValidationController.validate(password: password){
            return invalidPassword
        }
        else if let invalidConfPassword = ValidationController.validateComparePassword(password: password, confirmPassword: ConfPassword){
            return invalidConfPassword
        }
        else if let invalidDob = ValidationController.validateDob(dob: dob){
            return invalidDob
        }
        return nil
    }
    ///Compaire password with  confirm password ------
    static func validateComparePassword(password: String, confirmPassword: String) -> String?{
         if let invalidPassword = ValidationController.validate(password: password){
            return invalidPassword
        }
         else if password != confirmPassword{
            return "confirm password is did't match"
            
        }
        return nil
    }
    
    ///OTP Check ------
    static func validateForOTP(oTP: String) -> String?{
        if oTP.isEmpty{
            return "Please Enter OTP"
        }
        return nil
    }
    
    
    ///Login-------
    
    static func validateEmaPass(email: String,password : String) -> String? {
        if let invalidEmail = ValidationController.validateEmail(email: email){
            return invalidEmail
        }
        else if let invalidPassword = ValidationController.validate(password: password){
            return invalidPassword
        }
        return nil
    }
    
    ///Reset Password-------
    
    static func validateMobileNo(mobile: String) -> String? {
        if let invalidMobile = ValidationController.validateMobile(mobile: mobile){
            return invalidMobile
        }
       
        return nil
    }
    ///Reset Password-------
    static func validateOtp(otp: String) -> String? {
        if let invalidMobile = ValidationController.validateMobile(mobile: otp){
            return invalidMobile
        }
       
        return nil
    }
    
   
    
   
    
    ///Common For Password
    static func validate(password : String) -> String?{
        if password.isBlank {
            return "Please enter password"
        }
        else if password.byRemovingLeadingTrailingWhiteSpaces.count < 8 {
            return "Password must be atleast 8 character long"
        }
        else if !password.isStrongPassword {
            return "Password must contains combination of uppercase & lowercase letters , numbers and symbols (@#$%)"
        }
        return nil
    }
    
    ///Common For Country
    static func validateForCountry(country : String) -> String?{
        if country.isBlank {
            return "Please Select Country "
        }
        
        return nil
    }
    
    //Common For Email
    static func validateEmail(email : String) -> String?{
        if email.isBlank{
            return "Please enter email address"
        }
        else if !email.isEmail{
            return "please enter valid email address"
        }
        return nil
    }
    
    //Common For FristName
    static func validateFName(fname : String) -> String?{
        if fname.isBlank{
            return "Please enter name"
        }
        else if fname.count < 3{
            return "Name must be atleast 3 character long"
        }
        else if fname.count > 30 {
            return "Name can't be  not greater than 30 character"
        }
        
        return nil
    }
    
    //Common For LastName
    static func validateLName(lname : String) -> String?{
        if lname.isBlank{
            return "Please enter name"
        }
        else if lname.count < 3{
            return "Name must be atleast 3 character long"
        }
        else if lname.count > 30 {
            return "Name can't be  not greater than 30 character"
        }
        
        return nil
    }
    // Common for Date of birth
    static func validateDob(dob : String) -> String?{
        if dob.isBlank{
            return "Please enter Date of birth "
        }
       
        return nil
    }
    
    static func validateMobile(mobile : String) -> String?{
        if mobile.isBlank{
            return "Please enter mobile number"
        }
        else if mobile.count != 10{
            return "Please enter valid mobile number"
        }
        
        return nil
    }
 }

