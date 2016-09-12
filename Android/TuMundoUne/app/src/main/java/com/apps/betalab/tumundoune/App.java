package com.apps.betalab.tumundoune;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.graphics.Camera;

public class App extends AppCompatActivity {

    private Camera mCamera;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_app);
    }


}
