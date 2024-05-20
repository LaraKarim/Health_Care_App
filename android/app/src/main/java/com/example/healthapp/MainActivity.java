package com.example.healthapp;


import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.example.healthapp.NotificationHandler; // Import your NotificationHandler class

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());
        NotificationHandler.attach(this); // Attach the NotificationHandler
    }
}
