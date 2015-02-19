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


public class GroupsActivity extends ActionBarActivity {
    public final static String MESSAGE_KEY = "com.example.nickhauser.tap.MESSAGE";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_groups);

        //set up the list view which will contain search results
        final ListView groupList = (ListView) findViewById(R.id.people_list);
        groupList.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, new ArrayList<String>()));
        buttonSearch(null);

        //add the action listener for list items
        //which starts the group activity for the group clicked
        final Context parentContext = this;
        groupList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent groupClickedIntent = new Intent(parentContext, GroupActivity.class);
                String groupName = (String) groupList.getAdapter().getItem(position);
                groupClickedIntent.putExtra(MESSAGE_KEY, groupName);
                startActivity(groupClickedIntent);
            }
        });
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        buttonSearch(null);
    }

    //Perform create group action in response to button press
    public void buttonCreate(View view) {
        //get the group name
        EditText searchTextBox = (EditText) findViewById(R.id.search_text);
        String groupName = searchTextBox.getText().toString();

        //create the group or display an error
        if (Global.isStringValid(groupName, 16, false)) {
            createGroup(groupName);
        }else {
            Toast.makeText(this, "Group names must contain less than 16 letters and must not include spaces.", Toast.LENGTH_LONG).show();
        }
    }

    //Request that the server create a group with the name provided
    private void createGroup(String groupName) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }

    //Perform person search action in response to button press
    //expected behavior is that if the search is empty,
    //a list of the user's groups is returned;
    //if the search has a value,
    //a list of groups pertinent to that value is returned
    public void buttonSearch(View view) {
        //get the search string
        EditText searchTextBox = (EditText) findViewById(R.id.search_text);
        String searchKey = searchTextBox.getText().toString();

        //get the list of results to display
        Group[] results;
        if (searchKey.equals("")) {
            results = fetchGroups(Global.currentUser);
        }else {
            results = fetchSearch(Global.currentUser, searchKey);
        }

        //get the GUI objects
        ListView peopleList = (ListView) findViewById(R.id.people_list);
        ArrayAdapter<String> groups = (ArrayAdapter<String>) peopleList.getAdapter();
        groups.clear();

        //add the results to the GUI
        for (int i = 0; i < results.length; i++) {
            groups.add(results[i].getName());
        }
    }

    //Return a list of the user's groups from the server
    private Group[] fetchGroups(String currentUser) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        Group[] toRet = new Group[7];
        toRet[0] = new Group("Group A");
        toRet[1] = new Group("Group B");
        toRet[2] = new Group("Group C");
        toRet[3] = new Group("Group D");
        toRet[4] = new Group("Group E");
        toRet[5] = new Group("Group F");
        toRet[6] = new Group("Group G");
        return toRet;
    }

    //Return a list of the search results from the server
    private Group[] fetchSearch(String currentUser, String searchKey) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        Group[] toRet = new Group[4];
        toRet[0] = new Group("Group A");
        toRet[1] = new Group("Group C");
        toRet[2] = new Group("Group D");
        toRet[3] = new Group("Group E");
        return toRet;
    }
}