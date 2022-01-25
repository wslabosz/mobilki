import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/Screens/AddEvent/components/utils.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class NewEventForm extends StatefulWidget {
  final Event? event;
  const NewEventForm({Key? key, this.event}) : super(key: key);

  @override
  _NewEventFormState createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  List<Team> teamsList = [];
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late DateTime dateFrom;
  late String level;
  //location
  late GeoPoint location;
  final Completer<GoogleMapController> _mapController = Completer();
  late GoogleMapController newGoogleMapController;
  //late Position position = _determinePosition() as Position;
  late GeoPoint currlocation;
  final CameraPosition camera =
      CameraPosition(target: LatLng(51.759445, 19.457216), zoom: 5);
  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currlocation = GeoPoint(position.latitude, position.longitude);
    CameraPosition c = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(c));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      dateFrom = DateTime.now();
    }
    FirebaseFirestore.instance
        .collection('teams')
        .where('members', arrayContains: AuthMethods().getUserUID())
        .snapshots()
        .listen((snapshot) {
      teamsList = snapshot.docs.map((doc) => (Team.fromSnap(doc))).toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: buildForm(),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildName(),
                  const SizedBox(height: 20),
                  buildDateTimePickers(),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    hint: const Text('Difficulty level'),
                    items: <int>[1, 2, 3].map((int value) {
                      return DropdownMenuItem(
                          value: value, child: Text('$value'));
                    }).toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    items: getDropDownTeams(),
                    hint: const Text('Team'),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'LOCATION',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: GoogleMap(
                      initialCameraPosition: camera,
                      zoomControlsEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                        newGoogleMapController = controller;
                        _determinePosition();
                      },
                    ),
                  )
                ],
              ))));

  List<Widget> buildForm() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {},
            icon: const Icon(Icons.done),
            label: const Text('SAVE'))
      ];

  Widget buildName() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(hintText: 'Name'),
        onFieldSubmitted: (_) {},
        validator: (String? value) {
          //TODO: Walidacja długości
          if (value == null || value.isEmpty) {
            return 'Please enter event name';
          }
          return null;
        },
        controller: nameController,
      );

  Widget buildDateTimePickers() => Column(
        children: [buildFrom()],
      );

  Widget buildFrom() => buildHeader(
      header: 'DATE',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(dateFrom),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(dateFrom),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          )
        ],
      ));

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(dateFrom, pickDate: pickDate);
    if (date == null) return;
    setState(() => dateFrom = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.orange, // header background color
                  onPrimary: Colors.black, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.red, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2020, 12),
          lastDate: DateTime(2101));
      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.orange, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: TextStyle(fontSize: 14)),
          child,
        ],
      );

  List<DropdownMenuItem<String?>> getDropDownTeams() {
    List<DropdownMenuItem<String?>> items = [];
    items.add(const DropdownMenuItem(value: '', child: Text('Public')));
    for (Team team in teamsList) {
      items.add(DropdownMenuItem(value: team.uid, child: Text(team.name)));
    }
    return items;
  }
}

//TODO: lokalizacja
//TODO: participants: z uczestnikiem tworzącym
//TODO: zczytywanie fromularza i tworzenie obiektu Event i dodawanie nowego Eventu do bazy
