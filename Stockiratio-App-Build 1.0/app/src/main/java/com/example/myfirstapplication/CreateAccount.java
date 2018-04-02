package com.example.myfirstapplication;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class CreateAccount extends AppCompatActivity {

    final String number = "1234567890";
    final String specialChar = " !#$%&'()*+,-./:;<=>?@[]^_`{|}~" + '"';
    final String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private boolean isReady;



    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_account);

        final EditText firstName = (EditText) findViewById(R.id.create_account_FN);
        final EditText lastName = (EditText) findViewById(R.id.create_account_LN);
        final EditText username = (EditText) findViewById(R.id.create_account_username);
        final EditText password = (EditText) findViewById(R.id.create_account_password);
        final EditText passConfirm = (EditText) findViewById(R.id.create_account_passConfirm);
        final Button goToSignIn = (Button) findViewById(R.id.create_account_button);
        isReady = true;


        password.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if(password.getText().toString().length() < 8)
                {
                    password.setError("Must be 8 or more characters");
                }
                if(!containsAny(password.getText().toString(),number)){
                    password.setError("Must contain at least one number");
                }
                if(!containsAny(password.getText().toString(),specialChar)){
                    password.setError("Must contain at least one specialChar");
                }
                if(!containsAny(password.getText().toString(),upperCase)){
                    password.setError("Must contain at least one upperCase");
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                if(password.getText().toString().length() < 8)
                {
                    password.setError("Must be 8 or more characters");
                }
                if(!containsAny(password.getText().toString(),number)){
                    password.setError("Must contain at least one number");
                }
                if(!containsAny(password.getText().toString(),specialChar)){
                    password.setError("Must contain at least one specialChar");
                }
                if(!containsAny(password.getText().toString(),upperCase)){
                    password.setError("Must contain at least one upperCase");
                }
            }
        });

        passConfirm.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if(!password.getText().toString().equals(passConfirm.getText().toString())){
                    passConfirm.setError("Passwords must match");
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                if(!password.getText().toString().equals(passConfirm.getText().toString())){
                    passConfirm.setError("Passwords must match");
                }
            }
        });

        /*
        firstName.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if(firstName.getText().toString().length() < 2) {
                    firstName.setError("First name must contain two or more characters");
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
                if(firstName.getText().toString().length() < 2) {
                    firstName.setError("First name must contain two or more characters");
                }
            }
        });

        lastName.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

                if(lastName.getText().toString().length() < 2){
                    lastName.setError("Last name must contain two or more characters");
                }

            }

            @Override
            public void afterTextChanged(Editable s) {
                if(lastName.getText().toString().length() < 2){
                    lastName.setError("Last name must contain two or more characters");
                }
            }
        });

        username.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

                if(username.getText().toString().length() == 0){
                    username.setError("Username must contain one or more character");
                }

            }

            @Override
            public void afterTextChanged(Editable s) {
                if(username.getText().toString().length() == 0){
                    username.setError("Username must contain one or more character");
                }
            }
        });
           */
            /*
            if(password.getError() != null){
               isReady = false;
            }
            if(passConfirm.getError() != null){
                isReady = false;
            }
            */


    }
/*
    public void checker(View view){
        boolean isReady = true;

        if(isReady == true) {
            goToSignIn(view);
        }
    }
*/


    public void goToSignIn(View view){

        final EditText firstName = (EditText) findViewById(R.id.create_account_FN);
        final EditText lastName = (EditText) findViewById(R.id.create_account_LN);
        final EditText username = (EditText) findViewById(R.id.create_account_username);
        final EditText password = (EditText) findViewById(R.id.create_account_password);
        final EditText passConfirm = (EditText) findViewById(R.id.create_account_passConfirm);
        final Button goToSignIn = (Button) findViewById(R.id.create_account_button);

       // firstName.setText("" + isReady);

        if(firstName.getText().toString().length() == 0 || lastName.getText().toString().length() == 0 ||
        username.getText().toString().length() == 0 || password.getText().toString().length() == 0 ||
        passConfirm.getText().toString().length() == 0 || passConfirm.getError() != null || password.getError() != null ||
        !passConfirm.getText().toString().equals(password.getText().toString())) {
            isReady = false;
        }
        else{
            isReady = true;
        }

        //firstName.setText("" + isReady);

        if(getReady() == true){
            Intent myIntent = new Intent(this, LoginScreen.class);
            startActivity(myIntent);
        }
        else{

        }


    }


    public boolean containsAny(String input, String checkFor){
        boolean ret = false;

        for(int i = 0; i < input.length(); i++)
        {
            if(checkFor.indexOf(input.charAt(i)) >= 0){
                ret = true;
            }
        }
        return ret;
    }

    private boolean getReady(){
        return isReady;
    }

/*
    public void usernameCheck(String string){
        String username = string;


    }

    public boolean passwordCheck(String string){
        boolean okNum = false;
        boolean okSpec = false;
        boolean okUpper = false;
        String password = string;
        int count = 0;

        for(int i =0; i < password.length(); i++){

            if(number.indexOf(password.charAt(i)) < 0) {
                ret = true;
            }
            if(specialChar.indexOf(password.charAt(i)) < 0){
                ret = true;
            }

        }

    }
    */



}
