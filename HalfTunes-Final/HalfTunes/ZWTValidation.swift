//
//  ZWTValidation.swift
//  DriveAbout
//
//  Created by Vivek on 31/1/17.
//  Copyright © 2017 vivekMac. All rights reserved.
//

import UIKit

enum ZWTValidationType {
    case blank
    case email
    case name
    case password
    case number
    case phoneNumber
    case integer
    case alphaNoSpace
    case alphaWithSpace
    case alphaNumericNospace
    case alphaNumericWithspace
    case regExp
}

enum ZWTValidationResult {
    case valid
    case invalid
    case blank
    case notAlpha
    case notNumber
    case notInteger
    case lessLength
    case moreLength
    case containSpace
}

class ZWTValidation: NSObject {
    
    //MARK:
    class func isBlank(_ string:String?) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        
        
        guard string!.trimmedLength > 0 else {
            return .blank
        }
        
        return .valid
    }
    
    class func validateEmail(_ email:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = email else {
            return .blank
        }
        
        guard isRequire == true && email!.length > 0 else {
            return .blank
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return validateString(email!, againstRegExp: emailRegex)
    }
    
    class func validatePassword(_ password:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = password else {
            return .blank
        }
        
        guard isRequire == true && password!.length > 0 else {
            return .blank
        }
        
        guard password == password!.trimmed else {
            return .containSpace
        }
        
        let result = self.validateLength(password, min: 6, max: 20, isRequire: true)
        
        guard result == .valid else {
            return result
        }
        
        return .valid
//        let passwordRegex = "^(?=.{6,32}$)(?=.*[A-Z]).*$"
//        
//        return validateString(password!, againstRegExp: passwordRegex)
    }
    
    class func validateName(_ name:String?, isRequire:Bool) -> ZWTValidationResult {
        
        let result = validateLength(name!.trimmed, min: 2, max: 50, isRequire: isRequire)
        
        guard result == .valid else {
            return result
        }
        
        return validateString(name!.trimmed, againstRegExp: "(^[A-Za-z .'-]{2,50})")
    }
    
    //MARK:
    class func validateNumber(_ number:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = number else {
            return .blank
        }
        
        guard isRequire == true && number!.length > 0 else {
            return .blank
        }
        
        let formatter = NumberFormatter()
        let isNumber = formatter.number(from: number!)
        
        guard let _ = isNumber else {
            return .invalid
        }
        
        return .valid
    }
    
    //MARK:
    class func validatePhoneNumber(_ number:String?, isRequire:Bool) -> ZWTValidationResult {
        
        let result = validateLength(number!.trimmed, min: 10, max: 10, isRequire: isRequire)
        
        guard result == .valid else {
            return result
        }
        
        return validateString(number!.trimmed, againstRegExp: "^\\d+$")
    }
    
    class func validateInteger(_ integer:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = integer else {
            return .blank
        }
        
        guard isRequire == true && integer!.length > 0 else {
            return .blank
        }
        
        guard let _ = Int(integer!) else {
            return .invalid
        }
        
        return .valid
    }
    
    //MARK:
    class func validateAlphaNoSpace(_ string:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.trimmedLength > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z]+")
    }
    
    class func validateAlphaWithSpace(_ string:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z ]+")
    }
    
    class func validateAlphaNumericNoSpace(_ string:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.trimmedLength > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z0-9]+")
    }
    
    class func validateAlphaNumericWithSpace(_ string:String?, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        return validateString(string!, againstRegExp: "[A-Za-z0-9 ]+")
    }
    
    //MARK:
    class func validateLength(_ string:String?, min:Int, max:Int, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        guard string!.length >= min else {
            return .lessLength
        }
        
        guard string!.length <= max else {
            return .moreLength
        }
        
        return .valid
    }
    
    class func validateMinLength(_ string:String?, min:Int, isRequire:Bool) -> ZWTValidationResult {
        
        guard let _ = string else {
            return .blank
        }
        
        guard isRequire == true && string!.length > 0 else {
            return .blank
        }
        
        guard string!.length >= min else {
            return .lessLength
        }
        
        return .valid
    }
    
    //MARK:
    class func validateString(_ string:String, againstRegExp regExp:String) -> ZWTValidationResult {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", regExp)
        
        if emailTest.evaluate(with: string) {
            return .valid
        } else {
            return .invalid
        }
    }
    
    //MARK:
    class func validateDate(_ date:Date?, isAfterDate pastDate:Date?) -> ZWTValidationResult {
        
        guard date!.compare(pastDate!) == .orderedDescending else {
            return .invalid
        }
        
        return .valid
    }
    
    class func validateDate(_ date:Date?, isBeforeDate futureDate:Date?) -> ZWTValidationResult {
        
        guard date!.compare(futureDate!) == .orderedAscending else {
            return .invalid
        }
        
        return .valid
    }
    
    class func validateDate(_ date:Date?, isBetweenDate firstDate:Date, andDate secondDate:Date) -> ZWTValidationResult {
        
        guard date!.compare(firstDate) == .orderedDescending else {
            return .invalid
        }
        
        guard date!.compare(secondDate) == .orderedAscending else {
            return .invalid
        }
        
        return .valid
    }
}

extension UITextField {
    
    func validate(ZWTValidationType type:ZWTValidationType, getFocus focusOnError:Bool = false, alertMessage message:String = "") -> ZWTValidationResult {
        
        var result : ZWTValidationResult?
        
        switch type {
        case .blank:
            result = ZWTValidation.isBlank(text)
        case .email:
            result = ZWTValidation.validateEmail(text, isRequire: true)
        case .password:
            result = ZWTValidation.validatePassword(text, isRequire: true)
        case .name:
            result = ZWTValidation.validateName(text, isRequire: true)
        case .number:
            result = ZWTValidation.validateNumber(text, isRequire: true)
        case .phoneNumber:
            result = ZWTValidation.validatePhoneNumber(text, isRequire: true)
        case .integer:
            result = ZWTValidation.validateInteger(text, isRequire: true)
        case .alphaNoSpace:
            result = ZWTValidation.validateAlphaNoSpace(text, isRequire: true)
        case .alphaWithSpace:
            result = ZWTValidation.validateAlphaWithSpace(text, isRequire: true)
        case .alphaNumericNospace:
            result = ZWTValidation.validateAlphaNumericNoSpace(text, isRequire: true)
        case .alphaNumericWithspace:
            result = ZWTValidation.validateAlphaNumericWithSpace(text, isRequire: true)
        default:
            result = ZWTValidation.isBlank(text)
        }
        
        if focusOnError == true {
            if result != .valid {
                becomeFirstResponder()
            }
        }
        
        if message.trimmedLength > 0 {
            //show alert here
        }
        
        return result!
    }
    
    func validateWithRegExp(expression regExp:String, showRedRect errorRect:Bool = false, getFocus focusOnError:Bool = false, alertMessage message:String = "") -> ZWTValidationResult {
        
        let result = ZWTValidation.validateString(text!, againstRegExp: regExp)
        
        if  errorRect == true {
            //    if(result != ZWTZWTValidationResultValid)
            //    {
            //        (self.layer).borderWidth = 2;
            //        (self.layer).borderColor = [UIColor mainRedColor].CGColor;
            //        [self setClipsToBounds:YES];
            //    }
            //    else
            //    {
            //        (self.layer).borderWidth = 0;
            //        (self.layer).borderColor = [UIColor clearColor].CGColor;
            //        [self setClipsToBounds:NO];
            //    }
        }
        
        if focusOnError == true {
            becomeFirstResponder()
        }
        
        if message.trimmedLength > 0 {
            //show alert here
        }
        
        return result
    }
    
}

