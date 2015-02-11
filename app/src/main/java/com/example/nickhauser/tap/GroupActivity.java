package com.example.nickhauser.tap;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;


public class GroupActivity extends ActionBarActivity {
    private String groupSelected;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group);

        //store the name of the group whose page is being viewed
        //and update the page title to reflect that data
        groupSelected = getIntent().getStringExtra(GroupsActivity.MESSAGE_KEY);
        TextView titleTxt = (TextView) findViewById(R.id.title_label);
        titleTxt.setText(groupSelected);
    }

    //Perform leave group action in response to button press
    public void buttonLeave(View view) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        finish();
    }

    //Perform tap action in response to button press
    //record the length of the button press and
    //send it as a vibration of that length to
    //all members of the current group
    public void buttonTap(View view) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }
}