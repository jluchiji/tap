package com.example.nickhauser.tap;

/**
 * Created by Nick Hauser on 2/9/2015.
 * Class exists to globally track the current user
 * This is needed for requests to the server
 */
public class Global {
    public static String currentUser;

    //Validate a string based on length and content
    //the string should be less than maxLen
    //if spacesAllowed is false, spaces should not be allowed
    public static boolean isStringValid(String toValidate, int maxLen, boolean spacesAllowed) {
        //check the length
        if (toValidate.length() >= maxLen) {
            return false;
        }
        //check for spaces
        if (!spacesAllowed) {
            for (int i = 0; i < toValidate.length(); i++) {
                if (toValidate.charAt(i) == ' ') {
                    return false;
                }
            }
        }
        return true;
    }
}
