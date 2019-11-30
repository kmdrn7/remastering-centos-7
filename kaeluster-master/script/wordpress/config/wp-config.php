<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );
/** MySQL database username */
define( 'DB_USER', 'wpuser' );
/** MySQL database password */
define( 'DB_PASSWORD', 'wppassword' );
/** MySQL hostname */
define( 'DB_HOST', 'localhost' );
/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );
/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );
/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'BzrNAx ~cF@kf{y,P{UeZ_2N&gv@>]7g5k]+dhC=4;O+f&<k]}D86<[zjXN9|S8k');
define('SECURE_AUTH_KEY',  '5?(W|r4R=Mj-@+C)^56_>0k;9!>irhzN=;pP2SwG; sZ-Z.K2Iz|%<l&p%8|SS}K');
define('LOGGED_IN_KEY',    ']G#y_o^IF_pUWrHZgrwS8+RP1+Xn& ?~VJ0p%+JiHE@s}WI5W;**$$pu_[uw+_1z');
define('NONCE_KEY',        ',GS`R2-DH_21!(`ex*z7|BCdU?q@}b-/gB]E|Rkdj1d)bxo[vG[nh=gab<1H+mzr');
define('AUTH_SALT',        '9>th]}_sC<*_A4 f9e:+ oQmXQ%Zw~^R~66Nu,>%Hrc5^;:0v$VDzEQ~u?J#7ZX+');
define('SECURE_AUTH_SALT', 'Gd>z6}K:U7Q+o<zm7bZ|MPF3h^_vc?x%gW+.N M+]r(i`Irv)zjT71;:jX-TuMwh');
define('LOGGED_IN_SALT',   'v|U*,WkOW_V8|Lg/)ZK=}zoKP OV0;F1x0;=X<+7{O,#]p&I[vGAH+R XLDaC+44');
define('NONCE_SALT',       '2YvSc@=q2&jp` g5]>#:Xh2Od>dR:6J(eODQxc4>&tUUTgSP!qW%w,lUlw9@9lxN');
/**#@-*/
/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';
/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );
/* That's all, stop editing! Happy publishing. */
/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );