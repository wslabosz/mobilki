import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }
    final TextEditingController _nameController = TextEditingController();
  String _search_value = "";

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: Text(
                  "Look for friends",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )),
          SizedBox(height: size.height * 0.03),
          InputField(
            hintText: "Name",
            textEditingController: _nameController,
            textInputType: TextInputType.name,
            onChanged: (value) {
              setState(() {
                _search_value = value.toLowerCase();
              });
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (_search_value.length < 3) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData) return const Text("No results found");
                var data = snapshot.data!.docs;
                data = data
                    .where((x) => (x['name'] as String).contains(_search_value))
                    .toList();
                var count = data.length;
                return Expanded(
                    child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 4,
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle, color: orange),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text((data[index]['name'][0]+data[index]['name'][(data[index]['name'] as String).indexOf(' ')+1] as String).toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18))
                                        ]))),
                            Expanded(
                                flex: 13,
                                child: Text(
                                    ((data[index]['name']) as String)
                                        .toTitleCase(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18))),
                            Expanded(
                                flex: 3,
                                child: Container(child: const Icon(Icons.add)))
                          ],
                        ));
                  },
                  itemCount: count,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ));
              }),
          SizedBox(height: size.height * 0.03),
        ]));
  }
}
