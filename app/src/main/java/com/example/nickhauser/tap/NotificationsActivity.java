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
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;


public class NotificationsActivity extends ActionBarActivity {
    private static final String DEFAULT_TYPE = "You do not have any notifications";
    private static final String DEFAULT_NAME = "at this time.";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifications);

        //set up the list view which will contain notifications
        final ListView notificationList = (ListView) findViewById(R.id.notification_list);
        notificationList.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, new ArrayList<String>()));
        Notification[] notifications = populateNotifications();

        //set the currently selected notification
        TextView selectionTypeText = (TextView) findViewById(R.id.selection_type_text);
        TextView selectionNameText = (TextView) findViewById(R.id.selection_name_text);
        if (notifications.length == 0) {
            selectionTypeText.setText(DEFAULT_TYPE);
            selectionNameText.setText(DEFAULT_NAME);
        }else {
            selectionTypeText.setText(notifications[0].getType());
            selectionNameText.setText(notifications[0].getName());
        }

        //add the action listener for list items
        //which which set the current selection when clicked
        notificationList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String notificationName = (String) notificationList.getAdapter().getItem(position);
                TextView selectionTypeText = (TextView) findViewById(R.id.selection_type_text);
                TextView selectionNameText = (TextView) findViewById(R.id.selection_name_text);
                selectionTypeText.setText(notificationName.split("\n")[0]);
                selectionNameText.setText(notificationName.split("\n")[1]);
            }
        });
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        populateNotifications();
    }

    //Repopulate the list of the user's notifications
    public Notification[] populateNotifications() {
        //get the list of results to display
        Notification[] results = fetchNotifications(Global.currentUser);

        //get the GUI objects
        ListView peopleList = (ListView) findViewById(R.id.notification_list);
        ArrayAdapter<String> notifications = (ArrayAdapter<String>) peopleList.getAdapter();
        notifications.clear();

        //add the results to the GUI
        for (int i = 0; i < results.length; i++) {
            notifications.add(results[i].toString());
        }

        //return the list of notifications
        return results;
    }

    //Return a list of the user's notifications from the server
    private Notification[] fetchNotifications(String currentUser) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
        Notification[] toRet = new Notification[6];
        toRet[0] = new Notification(Notification.FRIEND_REQUEST,"John Smith");
        toRet[1] = new Notification(Notification.GROUP_INVITE,"Lawyers");
        toRet[2] = new Notification(Notification.FRIEND_REQUEST,"Jane Smith");
        toRet[3] = new Notification(Notification.FRIEND_REQUEST,"John Watt");
        toRet[4] = new Notification(Notification.FRIEND_REQUEST,"Joan Smith");
        toRet[5] = new Notification(Notification.GROUP_INVITE,"Teachers");
        return toRet;
    }

    //Perform accept notification action in response to button press
    public void buttonAccept(View view) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }

    //Perform decline notification action in response to button press
    public void buttonDecline(View view) {
        //TODO - this should actually be implemented by a call to the server; this method is a stub
    }
}