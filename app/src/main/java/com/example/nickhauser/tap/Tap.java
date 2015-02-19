package com.example.nickhauser.tap;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.EditText;
import android.widget.Toast;


public class Tap extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tap);
    }

    //Perform log in action in response to button press
    //request credentials from the server
    //if they match, move into the app and save the username
    //otherwise, display an error message
    public void buttonLogIn(View view) {
        //get the username and password provided
        EditText textBox = (EditText) findViewById(R.id.username_text);
        String username = textBox.getText().toString();
        textBox = (EditText) findViewById(R.id.password_text);
        String password = textBox.getText().toString();

        //ask server to check whether the login credentials are valid
        if (areCredentialsValid(username, password)) {
            //enter the application
            Global.currentUser = username;
            startActivity(new Intent(this, MenuActivity.class));
        }else {
            //display an error message
            Toast.makeText(this, "Invalid username or password.", Toast.LENGTH_LONG).show();
        }
    }

    //Ask the server to validate a provided username password pair
    private boolean areCredentialsValid(String username, String password) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        return true;
    }

    //Create a new account in response to button press
    //request the server to validate credentials and check uniqueness
    //read the response denoting whether the server created the account
    //if the request succeeded, move into the app and save the username
    //otherwise, display an error message
    public void buttonCreateAccount(View view) {
        //get the username and password provided
        EditText textBox = (EditText) findViewById(R.id.username_text);
        String username = textBox.getText().toString();
        textBox = (EditText) findViewById(R.id.password_text);
        String password = textBox.getText().toString();

        //check that the provided credentials meet security requirements
        if (!Global.isStringValid(username, 16, false)) {
            Toast.makeText(this, "Usernames must contain less than 16 letters and must not include spaces.", Toast.LENGTH_LONG).show();
        }else if (!Global.isStringValid(password, 128, true)) {
            Toast.makeText(this, "Your password is too long.", Toast.LENGTH_LONG).show();
        }else if (accountExists(username)) {
            Toast.makeText(this, "An account with that name already exists.", Toast.LENGTH_LONG).show();
        }else {
            createAccount(username, password);
        }
    }

    //Ask the server whether the specified username already exists
    private boolean accountExists(String username) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        return false;
    }

    //Send a request to the server to create a new account using the supplied credentials
    private void createAccount(String username, String password) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }

    //Request a password reset in response to button press
    //display a message notifying the user the request will be processed
    public void buttonForgotPassword(View view) {
        Toast.makeText(this, "Your request will be processed by our admins; you will be emailed shortly.", Toast.LENGTH_LONG).show();
    }
}
