package com.example.nickhauser.tap;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;


public class PeopleActivity extends ActionBarActivity {
    public final static String MESSAGE_KEY = "com.example.nickhauser.tap.MESSAGE";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_people);

        //set up the list view which will contain search results
        //TODO (NGH) - this should display whether the user is a friend
        final ListView peopleList = (ListView) findViewById(R.id.people_list);
        peopleList.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, new ArrayList<String>()));
        buttonReset(null);

        //add the action listener for list items
        //which starts the person activity for the person clicked
        final Context parentContext = this;
        peopleList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent personClickedIntent = new Intent(parentContext, PersonActivity.class);
                String personName = (String) peopleList.getAdapter().getItem(position);
                personClickedIntent.putExtra(MESSAGE_KEY, personName);
                startActivity(personClickedIntent);
            }
        });
    }

    //Perform search reset action in response to button press
    //reset the value of the search box and execute the search
    public void buttonReset(View view) {
        EditText searchTextBox = (EditText) findViewById(R.id.search_text);
        searchTextBox.setText("");
        buttonSearch(view);
    }

    //Perform person search action in response to button press
    //expected behavior is that if the search is empty,
    //a list of the user's friends is returned;
    //if the search has a value,
    //a list of people pertinent to that value is returned
    public void buttonSearch(View view) {
        //get the search string
        EditText searchTextBox = (EditText) findViewById(R.id.search_text);
        String searchKey = searchTextBox.getText().toString();

        //get the list of results to display
        User[] results;
        if (searchKey.equals("")) {
            results = fetchFriends(Global.currentUser);
        }else {
            results = fetchSearch(searchKey);
        }

        //get the GUI objects
        ListView peopleList = (ListView) findViewById(R.id.people_list);
        ArrayAdapter<String> people = (ArrayAdapter<String>) peopleList.getAdapter();
        people.clear();

        //add the results to the GUI
        for (int i = 0; i < results.length; i++) {
            people.add(results[i].getName());
        }
    }

    //Return a list of the user's friends from the server
    private User[] fetchFriends(String currentUser) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        User[] toRet = new User[3];
        toRet[0] = new User("John");
        toRet[1] = new User("Jane");
        toRet[2] = new User("WTFpls");
        return toRet;
    }

    //Return a list of the search results from the server
    private User[] fetchSearch(String searchKey) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        User[] toRet = new User[3];
        toRet[0] = new User("anon");
        toRet[1] = new User("anon22");
        toRet[2] = new User("secretanon");
        return toRet;
    }
}
