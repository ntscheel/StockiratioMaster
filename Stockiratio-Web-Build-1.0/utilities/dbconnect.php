<?php
    $con = pg_connect("host=localhost port=5432 dbname=Production user=webdev password=WebUIisgr8");
    if(!$con){
        echo "Failed to connect to PostgreSQL";
    }