import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propertypal/widgets/auth_gate.dart';
import '../../widgets/add_unit_form.dart';

class ApartmentDetailsTab extends StatefulWidget {
  final Map<String, dynamic> property;

  const ApartmentDetailsTab({Key? key, required this.property}) : super(key: key);

  @override
  _DetailsTabState createState() => _DetailsTabState();
}

class _DetailsTabState extends State<ApartmentDetailsTab> {
  late TextEditingController _propertyNameController;
  late TextEditingController _propertyAddressController;
  late String? userId;
  final userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    userId = userID;
    _propertyNameController = TextEditingController(text: widget.property['propertyName']);
    _propertyAddressController = TextEditingController(text: widget.property['propertyAddress']);
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _unitsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('apartments')
        .doc(widget.property['propertyId']) // Use the dynamic property ID
        .collection('units')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _unitsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        //test case to check if unit has not been added
        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return Text('No units available');
        // }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Property Details',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Building Name",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(
                              "${widget.property['propertyName']}",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Address",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Text(
                              widget.property['propertyAddress'],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              "Units",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddUnitForm(propertyId: widget.property['propertyId']),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Use a ListView.builder for dynamic rendering of units and tenant names
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var unit = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "${unit['unitId']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Text(
                                  "${unit['tenantName']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Edit button
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the alignment as needed
                  children: [
                    SizedBox(
                      width: 200,
                      child: Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showEditDialog(context);
                          },
                          child: Text("Edit Details"),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 200,
                      child: Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showDeleteDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Use red color for delete button
                          ),
                          child: Text("Delete Details"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Apartment'),
          content: Text('Are you sure you want to delete this apartment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _deleteFirestoreEntry();
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  void _deleteFirestoreEntry() async {
    var collection = " ";
    if (widget.property['propertyId'].contains('property')) {
      collection = "properties";
    } else if (widget.property['propertyId'].contains('apartment')) {
      collection = "apartments";
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('apartments')
        .doc(widget.property['propertyId'])
        .collection('units')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(collection)
        .doc(widget.property['propertyId'])
        .delete()
        .then((_) {
      print("Firestore delete successful");

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => AuthGate(),
        ),
            (route) => false,
      );
    }).catchError((error) {
      // Handle errors here
      print("Error deleting Firestore entry: $error");
    });
  }

  Future<void> _showEditDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _propertyNameController,
                  decoration: InputDecoration(labelText: 'Property Name'),
                ),
                TextFormField(
                  controller: _propertyAddressController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Property Address'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _updateFirestore();
                });
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AuthGate(),
                  ),
                      (route) => false,
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateFirestore() {
    var collection = " ";
    if (widget.property['propertyId'].contains('property')) {
      collection = "properties";
    } else if (widget.property['propertyId'].contains('apartment')) {
      collection = "apartments";
    }
    FirebaseFirestore.instance.collection('users').doc(userId).collection(collection).doc(widget.property['propertyId']).update({
      'propertyName': _propertyNameController.text,
      'propertyAddress': _propertyAddressController.text,
    }).then((_) {
      print("Firestore update successful");
    }).catchError((error) {
      // Handle errors here
      print("Error updating Firestore: $error");
    });
  }

  @override
  void dispose() {
    _propertyNameController.dispose();
    _propertyAddressController.dispose();
    super.dispose();
  }
}
