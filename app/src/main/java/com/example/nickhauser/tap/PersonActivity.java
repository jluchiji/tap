package com.example.nickhauser.tap;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;


public class PersonActivity extends ActionBarActivity {
    private final static String ALREADY_FRIENDS_STATUS = "This user is your friend.";
    private final static String REQUEST_SENT_STATUS = "You have sent this user a friend request.";
    private final static String NOT_FRIENDS_STATUS = "This user is not your friend.";
    private String personSelected;
    private String relationshipStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person);

        //store the name of the user whose page is being viewed
        //and update the page title to reflect that data
        personSelected = getIntent().getStringExtra(PeopleActivity.MESSAGE_KEY);
        TextView titleTxt = (TextView) findViewById(R.id.title_label);
        titleTxt.setText(personSelected);

        //update the status text with the person's relationship status
        setPersonRelationship();

        //update the group options with the active user's groups
        setGroupOptions();
    }

    //Update the GUI with the current user's relationship to the user they are viewing
    private void setPersonRelationship() {
        TextView relationshipStatusText = (TextView) findViewById(R.id.friends_label);
        relationshipStatus = NOT_FRIENDS_STATUS;
        if (areUsersFriends(Global.currentUser, personSelected)) {
            relationshipStatus = ALREADY_FRIENDS_STATUS;
        }else if (friendRequestSent(Global.currentUser, personSelected)) {
            relationshipStatus = REQUEST_SENT_STATUS;
        }
        relationshipStatusText.setText(relationshipStatus);
    }

    //Ask the server whether the current user and the user they are viewing are friends
    private boolean areUsersFriends(String current, String selected) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        return (personSelected.charAt(0) == 'J');
    }

    //Ask the server whether the current user has sent a friend request to the user they are viewing
    private boolean friendRequestSent(String current, String selected) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        return (personSelected.charAt(0) == 'a');
    }

    //Update the GUI by adding the active user's groups to the options for group invitations
    private void setGroupOptions() {
        //find the spinner and create its item list
        final Spinner peopleList = (Spinner) findViewById(R.id.groups_spinner);
        peopleList.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, new ArrayList<String>()));

        //get a list of the current user's groups from the server
        Group[] results = fetchGroups(Global.currentUser);

        //add the results to the GUI
        ArrayAdapter<String> people = (ArrayAdapter<String>) peopleList.getAdapter();
        for (int i = 0; i < results.length; i++) {
            people.add(results[i].getName());
        }
    }

    //Return a list of the current user's groups from the server
    private Group[] fetchGroups(String currentUser) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        Group[] toRet = new Group[4];
        toRet[0] = new Group("Cheaters");
        toRet[1] = new Group("Businessmen");
        toRet[2] = new Group("Secretaries");
        toRet[3] = new Group("Athletes");
        return toRet;
    }

    //Perform friend request action in response to button press
    //change the relationship status text and ask the server to send the request
    //if such a request was not already sent, otherwise, display an error
    public void buttonRequest(View view) {
        if (relationshipStatus.equals(NOT_FRIENDS_STATUS)) {
            TextView relationshipStatusText = (TextView) findViewById(R.id.friends_label);
            relationshipStatus = REQUEST_SENT_STATUS;
            relationshipStatusText.setText(relationshipStatus);
            createRequest(Global.currentUser, personSelected);
        }else if (relationshipStatus.equals(REQUEST_SENT_STATUS)) {
            Toast.makeText(this, "You have already sent this user a friend request.", Toast.LENGTH_LONG).show();
        }else {
            Toast.makeText(this, "This user is already your friend.", Toast.LENGTH_LONG).show();
        }
    }

    //Ask the server to generate a friend request from the current user to the user being viewed
    private void createRequest(String current, String selected) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }

    //Perform friend request action in response to button press
    //change the relationship status text and ask the server to send the request
    public void buttonInvite(View view) {
        Spinner groupOptions = (Spinner) findViewById(R.id.groups_spinner);
        String groupSelected = (String) groupOptions.getSelectedItem();
        if (!relationshipStatus.equals(ALREADY_FRIENDS_STATUS)) {
            Toast.makeText(this, "You cannot invite someone to a group without adding them to your friends.", Toast.LENGTH_LONG).show();
        }else if (groupInviteSent(groupSelected, personSelected)) {
            Toast.makeText(this, "This person has already been invited.", Toast.LENGTH_LONG).show();
        }else {
            createInvite(groupSelected, personSelected);
        }
    }

    //Ask the server whether the recipient has already been invited to the group
    private boolean groupInviteSent(String group, String recipient) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        return false;
    }

    //Ask the server to generate a group invite to the user being viewed for the selected group
    private void createInvite(String group, String recipient) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }
}
