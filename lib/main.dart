import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const HurryCanUHelpApp());
} 

class HurryCanUHelpApp extends StatelessWidget {
  const HurryCanUHelpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HurryCanUHelp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HurryCanUHelpHomePage(),
    );
  }
}

class HurryCanUHelpHomePage extends StatefulWidget {
  const HurryCanUHelpHomePage({super.key});

  @override
  State<HurryCanUHelpHomePage> createState() => _HurryCanUHelpHomePageState();
}

class _HurryCanUHelpHomePageState extends State<HurryCanUHelpHomePage> {
  GoogleMapController? mapController;
  LatLng? _center;
  Position? _currentPosition;
  // Reference to Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    // Request permission to get the user's location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    // Get the current location of the user
    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    });
  }

  //-------------------------------------------------------------------------
  Future<void> _sendEvacuationMessage() async {
    if (_currentPosition != null) {
      try {
        await _firestore.collection('hurricane_requests').add({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'message': 'evacuate',
          'timestamp': FieldValue.serverTimestamp(),
        });

        await Future.delayed(const Duration(seconds: 1));
        // Show success message
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Evacuation request sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending evacuation request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //-------------------------------------------------------------------------
  Future<void> _sendFoodMessage() async {
    if (_currentPosition != null) {
      try {
        await _firestore.collection('hurricane_requests').add({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'message': 'food',
          'timestamp': FieldValue.serverTimestamp(),
        });

        await Future.delayed(const Duration(seconds: 1));
        // Show success message
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Food request sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending food request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //-------------------------------------------------------------------------
  Future<void> _sendMedicalMessage() async {
    if (_currentPosition != null) {
      try {
        await _firestore.collection('hurricane_requests').add({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'message': 'medical',
          'timestamp': FieldValue.serverTimestamp(),
        });

        await Future.delayed(const Duration(seconds: 1));
        // Show success message
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medical request sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending medical request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //-------------------------------------------------------------------------
  Future<void> _sendShelterMessage() async {
    if (_currentPosition != null) {
      try {
        await _firestore.collection('hurricane_requests').add({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'message': 'shelter',
          'timestamp': FieldValue.serverTimestamp(),
        });

        await Future.delayed(const Duration(seconds: 1));
        // Show success message
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shelter request sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending shelter request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hurry Can U Help!'),
      ),
      body: _center == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center!,
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('user_location'),
                        position: _center!,
                        infoWindow: InfoWindow(
                            title:
                                "Current Position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}"),
                      ),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton.icon(
                                onPressed: _sendEvacuationMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.airline_seat_flat),
                                label: const Text('Evacuate'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton.icon(
                                onPressed: _sendFoodMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.fastfood),
                                label: const Text('Food'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton.icon(
                                onPressed: _sendMedicalMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.red,
                                ),
                                icon: const Icon(Icons.medical_services),
                                label: const Text('Medical'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton.icon(
                                onPressed: _sendShelterMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                ),
                                icon: const Icon(Icons.church),
                                label: const Text('Shelter'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  } //-------------------------------------------------------------------------
}
