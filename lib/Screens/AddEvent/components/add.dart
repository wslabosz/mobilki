import 'package:flutter/material.dart';
import 'package:mobilki/Screens/AddEvent/components/utils.dart';
import 'package:mobilki/models/event.dart';

class NewEventForm extends StatefulWidget {
  final Event? event;
  const NewEventForm({Key? key, this.event}) : super(key: key);

  @override
  _NewEventFormState createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late DateTime dateFrom;
  late String level;
  List levels = [1, 2, 3];

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
}
