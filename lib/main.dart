import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/providers/photographer_provider.dart';
import 'package:flutter_application_1/providers/team_provider.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:flutter_application_1/providers/venue_provider.dart';
import 'package:flutter_application_1/screens/Ft_welcom_screen.dart';
import 'package:flutter_application_1/screens/Login.dart';
import 'package:flutter_application_1/screens/admin_screens/add_admin.dart';
import 'package:flutter_application_1/screens/admin_screens/admin_pannel.dart';
import 'package:flutter_application_1/screens/admin_screens/admin_registration.dart';
import 'package:flutter_application_1/screens/catering_services_pages/catering_form_request.dart';
import 'package:flutter_application_1/screens/catering_services_pages/catering_screen.dart';
import 'package:flutter_application_1/screens/form.dart';
import 'package:flutter_application_1/screens/organizer_service_screens.dart/organizing_team_screen.dart';
import 'package:flutter_application_1/screens/service_provder_screens/servce_provider_signup_screen.dart';
import 'package:flutter_application_1/screens/userscreens/catering_booking_screen.dart';
import 'package:flutter_application_1/screens/userscreens/usignup_screen.dart';
import 'package:flutter_application_1/screens/venues_services/venues_screen.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/profile_Screen.dart';
import 'screens/userscreens/uhome_screen.dart';
import 'screens/photographers_services_screens/photographer_screen.dart';
import 'screens/userscreens/checkout_screen.dart';
import 'screens/service_provder_screens/service_providerpannel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set Firestore settings here
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true, // Enable offline persistence
    cacheSizeBytes:
        Settings.CACHE_SIZE_UNLIMITED, // Set cache size to unlimited
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => VenueProvider()),
        ChangeNotifierProvider(create: (context) => TeamProvider()),
        ChangeNotifierProvider(create: (context) => PhotographerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Booking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          }
          if (snapshot.hasData) {
            // User is logged in, fetch the role from Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (roleSnapshot.hasError) {
                  return Center(child: Text("Error: ${roleSnapshot.error}"));
                }
                if (roleSnapshot.hasData && roleSnapshot.data != null) {
                  Map<String, dynamic>? userData =
                      roleSnapshot.data!.data() as Map<String, dynamic>?;
                  if (userData == null || !userData.containsKey('role')) {
                    return Center(child: Text("Role not found for user."));
                  }

                  String role = userData['role'];
                  if (role == 'admin') {
                    return AdminHomePage();
                  } else if (role == 'service_provider') {
                    return handleServiceProvider(roleSnapshot.data!);
                  } else if (role == 'user') {
                    return uHomeScreen();
                  } else {
                    return Center(child: Text("Unknown role: $role"));
                  }
                }
                return Center(child: Text("Error fetching user role"));
              },
            );
          }
          return WelcomeScreen(); // User is not logged in
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/AdminRegistrationPage': (contex) => AdminRegistrationPage(),
        '/AddAdminScreen': (context) => AddAdminScreen(),
        '/ftwelcom': (context) => WelcomeScreen(),
        //admin pages
        '/adminhome': (context) => AdminHomePage(),
        '/cateringscreen': (context) => CateringScreen(),

        '/CateringBookingScreen': (context) => CateringBookingPage(),

        '/welcome': (context) => WelcomeScreen3(),
        '/login': (context) => LoginScreen(),
        //sign up screens
        '/usignup': (context) => USignupScreen(),
        '/serviceprovidersignup': (context) => ServiceProviderSignupScreen(),
        '/profile': (context) => ProfileScreen(),
        '/uhome': (context) => uHomeScreen(),
        '/venues': (context) => VenuesScreen(),

        '/organizing_team': (context) => OrganizingTeamScreen(),

        '/photographer': (context) => PhotographersScreen(),
        '/CateringRequestForm': (context) => CateringRequestForm(
              serviceProviderid: '',
            ),

        '/checkout': (context) => CheckoutScreen(),
        //providers

        '/booking form': (contex) => BookingFormPage(),

        '/admin_panel': (context) => AdminPanel(),
        // Admin Panel Route
      },
    );
  }
}

// ignore: public_member_api_docs
Widget handleServiceProvider(DocumentSnapshot userDoc) {
  Map<String, dynamic>? services = userDoc['services'] as Map<String, dynamic>?;

  if (services != null) {
    if (services['Photography Company'] == true) {
      return PhotographersScreen();
    } else if (services['Catering Company'] == true) {
      return CateringScreen();
    } else if (services['Venue Owner'] == true) {
      return VenuesScreen();
    } else if (services['Organizing Events Company'] == true) {
      return OrganizingTeamScreen();
    } else {
      return Center(child: Text('No valid service found for this provider'));
    }
  } else {
    return Center(child: Text('Services not set for this provider'));
  }
}
