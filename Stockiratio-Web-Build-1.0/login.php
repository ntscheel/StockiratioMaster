
<?php
    /* login.php
     * Description: A page that a user can either register their credentials
     *              or login if they already have a username/password
     * Features:
     * - Login form that authenticates a username/password pair, and if incorrect
     *   credentials are entered it will tell which of them is wrong with an error message
     * - Registration form that takes a username that isn't already in the database and a
     *   password associated it and sends it to the database to be stored
     * - After a user registers/logins they are redirected to the homepage
     */
    require dirname(__FILE__).'/include/error.php';
?>

<!DOCTYPE html>
<html>
	<head>
		<!-- Title and Flavicon -->
		<title>Stockiratio Login</title>
		<link rel="icon" href="Stockiratio-Web/img/icon.png"/>

		<!-- Metadata -->
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta name="description" content="Some description of this page pulled from somewhere">
		<meta name="keywords" content="Jason,Sawin,CISC490,Videogames,Elevator">

		<!-- Google Charts-->
		<script src="https://www.gstatic.com/charts/loader.js"></script>

		<!-- Foundation Framework files-->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.0.1/js/vendor/jquery.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.0.1/js/foundation.min.js"></script>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.0.1/css/foundation.css"/>

		<!-- Angular JS-->
		<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.1/angular.min.js"></script>

		<!-- Initialize Foundation -->
		<script> $(document).ready( function(){ $(document).foundation(); }); </script>

		<!--Custom CSS and JS-->
        <link rel="stylesheet" href="css/login.css">
        <script>
            function badLogin(){
                $('.login-error').css('display', 'block');
            }
        </script>
	</head>

	<body>
    <div class="row">
        <div class="small-6 large-centered columns">
            <div class="vertical-container">
                <h1 class="title-header">STOCKIRATIO</h1>

                <!-- Initialize tabs -->
                <ul class="tabs" data-tabs id="example-tabs">
                    <li class="tabs-title is-active"><a href="#login-panel" aria-selected="true">Login</a></li>
                    <li class="tabs-title"><a href="#register-panel">Register</a></li>
                </ul>

                <!-- Tab content - Login and Registration forms -->
                <div class="tabs-content" data-tabs-content="Login/Register tabs">
                    <div class="tabs-panel is-active" id="login-panel">
                        <!-- Login form -->
                        <form name="login-form" target="utilities/loginrequest.php">
                            <div class="row">
                                <div class="medium-12 columns">
                                    <label>Username
                                        <input type="text" name="username" placeholder="Username">
                                    </label>
                                    <label>Password
                                        <input type="password" name="password" placeholder="Password">
                                    </label>
                                    <input type="submit" class="button expanded" value="Login" form="login-form">
                                    <p class="login-error">Incorrect username or password.</p>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="tabs-panel" id="register-panel">
                        <!-- Registration form -->
                        <form name="registration-form" target="utilities/registerrequest.php">
                            <div class="row">
                                <div class="medium-4 columns">
                                    <label>Prefix
                                        <select>
                                            <option value="Mr">Mr.</option>
                                            <option value="Ms">Ms.</option>
                                            <option value="Mrs">Mrs.</option>
                                            <option value="Sr">Sr.</option>
                                            <option value="Sra">Sra.</option>
                                            <option value="Dr">Dr.</option>
                                        </select>
                                    </label>
                                </div>
                                <div class="medium-4 columns">
                                    <label>First Name
                                        <input type="text" placeholder="John">
                                    </label>
                                </div>
                                <div class="medium-4 columns">
                                    <label>Last Name
                                        <input type="text" placeholder="Doe">
                                    </label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="medium-12 columns">
                                    <label>Username
                                        <input type="text" name="username" placeholder="Username">
                                    </label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="medium-6 columns">
                                    <label>Password
                                        <input type="password" name="password1" placeholder="Password">
                                    </label>
                                </div>
                                <div class="medium-6 columns">
                                    <label>Repeat Password
                                        <input type="password" name="password2" placeholder="Password">
                                    </label>
                                </div>
                            </div>
                            <input type="submit" class="button expanded" value="Login" form="login-form">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
	</body>
</html>
