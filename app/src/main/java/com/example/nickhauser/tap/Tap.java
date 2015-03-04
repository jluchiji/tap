package com.example.nickhauser.tap;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.EditText;
import android.widget.Toast;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.*;
import org.json.JSONException;

import java.io.*;
import java.net.*;
import java.lang.Override;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;


public class Tap extends ActionBarActivity {
    Context tempContext;

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
        //start the validation thread
        tempContext = this;
        ValidateCredentials validateAcc = new ValidateCredentials();
        validateAcc.execute();
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
        } else if (!Global.isStringValid(password, 128, true)) {
            Toast.makeText(this, "Your password is too long.", Toast.LENGTH_LONG).show();
        } else if (accountExists(username)) {
            Toast.makeText(this, "An account with that name already exists.", Toast.LENGTH_LONG).show();
        } else {
            createAccount(username, password);
        }
    }


    //Ask the server whether the specified username already exists
    private boolean accountExists(String username) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        /*HttpClient httpclient = new DefaultHttpClient();
        URL url;
        String urlRead = "";
        HttpURLConnection conn;
        BufferedReader rd;
        String result = "";
        String line;

        try {
            url = new URL(urlRead);
            JSONObject list = new JSONObject();
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            while ((line = rd.readLine()) != null) {
                result += line;
            }
            rd.close();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }


        if (result.contains(username)) {
            return true;
        } else {
            return false;
        }*/

        return false;
    }

    //Send a request to the server to create a new account using the supplied credentials
    private void createAccount(String username, String password) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        tempContext = this;
        CreateCredentials createAcc = new CreateCredentials();
        createAcc.execute();
    }


    //Request a password reset in response to button press
    //display a message notifying the user the request will be processed
    public void buttonForgotPassword(View view) {
        Toast.makeText(this, "Your request will be processed by our admins; you will be emailed shortly.", Toast.LENGTH_LONG).show();
    }



    //Class to validate a username-password pair
    public class ValidateCredentials extends AsyncTask<String, Integer, JSONObject> {

        @Override
        protected JSONObject doInBackground(String... params) {
            //set up variables
            String urlRead = "http://wyvernzora.ninja:3000/api/auth";
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost(urlRead);

            //add the input values
            List nameValuePairs = new ArrayList();
            EditText textBox = (EditText) findViewById(R.id.username_text);
            nameValuePairs.add(new BasicNameValuePair("username", textBox.getText().toString()));
            textBox = (EditText) findViewById(R.id.password_text);
            nameValuePairs.add(new BasicNameValuePair("password", textBox.getText().toString()));

            //query the server
            HttpResponse response = null;
            try {
                httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
                response = httpclient.execute(httppost);
            }catch (Exception e) {
                e.printStackTrace();
            }

            //return the result
            JSONObject js = null;
            try {
                js = new JSONObject(EntityUtils.toString(response.getEntity()));
            }catch (Exception e) {
                e.printStackTrace();
            }
            return js;
        }

        @Override
        protected void onPostExecute(JSONObject result) {
            //move into the main app if the login succeeded, display error otherwise
            try {
                if (result.get("status").toString().equals("401")) {
                    Toast.makeText(tempContext, "Invalid username or password.", Toast.LENGTH_LONG).show();
                } else {
                    Global.currentUser = ((JSONObject)result.get("result")).get("uname").toString();
                    startActivity(new Intent(tempContext, MenuActivity.class));
                }
            }catch (JSONException e) {
                Toast.makeText(tempContext, "Login error; try again.", Toast.LENGTH_LONG).show();
            }
        }

    }


    //Class to create a username-password pair
    public class CreateCredentials extends AsyncTask<String, Integer, JSONObject> {

        @Override
        protected JSONObject doInBackground(String... params) {
            //set up variables
            String urlRead = "http://wyvernzora.ninja:3000/api/users";
            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost(urlRead);

            //add the input values
            List nameValuePairs = new ArrayList();
            EditText textBox = (EditText) findViewById(R.id.username_text);
            nameValuePairs.add(new BasicNameValuePair("username", textBox.getText().toString()));
            textBox = (EditText) findViewById(R.id.password_text);
            nameValuePairs.add(new BasicNameValuePair("password", textBox.getText().toString()));

            //query the server
            HttpResponse response = null;
            try {
                httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
                response = httpclient.execute(httppost);
            }catch (Exception e) {
                e.printStackTrace();
            }

            //return the result
            JSONObject js = null;
            try {
                js = new JSONObject(EntityUtils.toString(response.getEntity()));
            }catch (Exception e) {
                e.printStackTrace();
            }
            return js;
        }

        @Override
        protected void onPostExecute(JSONObject result) {
            //move into the main app if the login succeeded, display error otherwise
            try {
                if (result.get("status").toString().equals("500")) {
                    Toast.makeText(tempContext, "Database access failed.", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(tempContext, "Successful creation! You may now login.", Toast.LENGTH_LONG).show();
                }
            }catch (JSONException e) {
                Toast.makeText(tempContext, "Creation error; try again.", Toast.LENGTH_LONG).show();
            }
        }

    }
}