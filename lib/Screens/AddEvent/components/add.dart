import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/Screens/AddEvent/components/utils.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/resources/auth_methods.dart';

class NewEventForm extends StatefulWidget {
  final Event? event;
  const NewEventForm({Key? key, this.event}) : super(key: key);

  @override
  _NewEventFormState createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  List<Team?> teamsList = [null];
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late DateTime dateFrom;
  late String level;
  late List<DropdownMenuItem<Team?>> dropDownMenuTeams;

  //List<DropdownMenuItem>

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
      var userUID = AuthMethods().getUserUID();
      FirebaseFirestore.instance
          .collection('teams')
          .where('members', arrayContains: AuthMethods().getUserUID())
          .snapshots()
          .listen((snapshot) {
        teamsList = snapshot.docs.map((doc) => (Team.fromSnap(doc))).toList();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: buildForm(),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildName(),
                  SizedBox(height: 20),
                  buildDateTimePickers(),
                  SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    items: <int>[1, 2, 3].map((int value) {
                      return DropdownMenuItem(
                          value: value, child: Text('$value'));
                    }).toList(),
                    onChanged: (value) {},
                  ),
                  DropdownButtonFormField<String?>(
                    items: getDropDownTeams(),
                    onChanged: (value) {},
                  ),
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
    for (Team? team in teamsList) {
      items.add(DropdownMenuItem(value: team?.uid, child: Text(team!.name)));
    }
    return items;
  }
}
