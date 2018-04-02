package com.example.myfirstapplication;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;


public class DisplayMessageActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_display_message);

        Intent intent = getIntent();
        final String symbol = intent.getStringExtra(MainActivity.EXTRA_MESSAGE);
        final TextView textView = new TextView(this);
        textView.setTextSize(25);

//********************************************************************
        //This chunk of code was taken from URL=https://developer.android.com/training/volley/simple.html

        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(this);
        String url ="http://140.209.68.108:3000/snapshot/" + symbol;

        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        String companyName = "";
                        String price = "";
                        JSONObject stock = null;

                        try{
                            stock = new JSONObject(response);

                        } catch (Exception e) {
                            Log.e("MYAPP","unexpected JSON exception", e);
                        }
                        try {

                            companyName = stock.getString("name");
                            price = stock.getString("lastTradePriceOnly");
                        } catch (Exception e){
                            Log.e("MYAPP","unexpected JSON exception", e);
                        }

                        textView.setText("Name: " + companyName + "\n" + "Price: " + price);
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                textView.setText("That didn't work!");
            }
        });
// Add the request to the RequestQueue.
        queue.add(stringRequest);
//***********************************************************************

       //textView.setText(symbol);

        ViewGroup layout = (ViewGroup) findViewById(R.id.activity_display_message);
        layout.addView(textView);
    }


}
