import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_ngo/Admin/AdminHome.dart';
import 'package:project_ngo/components.dart';
import 'package:project_ngo/utils.dart';

class EditTrainingBudget extends StatefulWidget {
  @override
  _EditTrainingBudgetState createState() => _EditTrainingBudgetState();
}

class _EditTrainingBudgetState extends State<EditTrainingBudget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminUpBar(),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SubTitleText(text: "Manage Training Budget"),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Trainings Available"),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("trainings")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var training_data =
                                    snapshot.data!.docs[index].data();
                                return Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return EditTrainingBudgetView(
                                              id: snapshot.data!.docs[index].id,
                                              document: training_data);
                                        }));
                                      },
                                      child: Container(
                                        height: 120,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Color(0xFF29404E),
                                        ),
                                        child: Row(children: [
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(training_data['name'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      retrieveStringFormattedDate(
                                                          training_data[
                                                              'date']),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  "Edit Training Budget",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          )),
                                          Image.network(
                                            training_data['photo'],
                                            fit: BoxFit.cover,
                                            width: 120,
                                          )
                                        ]),
                                      ),
                                    ));
                              });
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })),
              AdminBottomBar()
            ],
          )),
        ));
  }
}

class EditTrainingBudgetView extends StatefulWidget {
  Map document;
  String id;
  EditTrainingBudgetView({required this.document, required this.id});
  @override
  _EditTrainingBudgetViewState createState() => _EditTrainingBudgetViewState();
}

class _EditTrainingBudgetViewState extends State<EditTrainingBudgetView> {
  double calculateTotal(List<dynamic> list) {
    double total = 0;
    list.forEach((element) {
      total += element['amount'] * element['quantity'];
    });
    return total;
  }

  List<dynamic> expenses = [];
  List<dynamic> sourceOfFunds = [];

  TextEditingController newExpenseName = TextEditingController();
  TextEditingController newExpenseQuantity = TextEditingController();
  TextEditingController newExpenseAmount = TextEditingController();
  TextEditingController newSourceName = TextEditingController();
  TextEditingController newSourceNameQuantity = TextEditingController();
  TextEditingController newSourceAmount = TextEditingController();

  @override
  void initState() {
    print(widget.document['expenses']);
    expenses = widget.document['expenses'] ?? [];
    sourceOfFunds = widget.document['sourceOfFunds'] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: AdminTheme,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF29404E),
            title: Text(widget.document['name']),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    Text("Expenses"),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name"),
                            ...expenses.map((e) {
                              return Text(e['name']);
                            })
                          ],
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Quantity"),
                            ...expenses.map((e) {
                              return Text(e['quantity'].toString());
                            })
                          ],
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Amount"),
                            ...expenses.map((e) {
                              return Text("P" + e['amount'].toString());
                            })
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Text("Total:"),
                        Expanded(child: SizedBox.shrink()),
                        Text("P" + calculateTotal(expenses).toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Source of Funds"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name"),
                            ...sourceOfFunds.map((e) {
                              return Text(e['name']);
                            }),
                          ],
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Quantity"),
                            ...sourceOfFunds.map((e) {
                              return Text(e['quantity'].toString());
                            })
                          ],
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Amount"),
                            ...sourceOfFunds.map((e) {
                              return Text("P" + e['amount'].toString());
                            })
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Text("Total:"),
                        Expanded(child: SizedBox.shrink()),
                        Text("P" + calculateTotal(sourceOfFunds).toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                )),
                Text("Add Expense"),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newExpenseName,
                        decoration: InputDecoration(
                            hintText: "Name", border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      width: 64,
                      child: TextField(
                        controller: newExpenseQuantity,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Qty", border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      width: 64,
                      child: TextField(
                        controller: newExpenseAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Price", border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var newExpenses = expenses;
                        newExpenses.add({
                          "name": newExpenseName.text,
                          "quantity": int.parse(newExpenseQuantity.text),
                          "amount": int.parse(newExpenseAmount.text)
                        });
                        await FirebaseFirestore.instance
                            .collection("trainings")
                            .doc(widget.id)
                            .update({
                          "expenses": newExpenses,
                          "sourceOfFunds": sourceOfFunds
                        });
                        setState(() {
                          expenses = newExpenses;
                          newExpenseName.clear();
                          newExpenseQuantity.clear();
                          newExpenseAmount.clear();
                        });
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please fill up all fields")));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Add Expense",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                SizedBox(
                  height: 16,
                ),
                Text("Add Source of Funds"),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: newSourceName,
                        decoration: InputDecoration(
                            hintText: "Name", border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      width: 64,
                      child: TextField(
                        controller: newSourceNameQuantity,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Qty", border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      width: 64,
                      child: TextField(
                        controller: newSourceAmount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Price", border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        var newSource = sourceOfFunds;
                        newSource.add({
                          "name": newSourceName.text,
                          "quantity": int.parse(newSourceNameQuantity.text),
                          "amount": int.parse(newSourceAmount.text)
                        });
                        await FirebaseFirestore.instance
                            .collection("trainings")
                            .doc(widget.id)
                            .update({
                          "expenses": expenses,
                          "sourceOfFunds": newSource
                        });
                        setState(() {
                          sourceOfFunds = newSource;
                          newSourceName.clear();
                          newSourceNameQuantity.clear();
                          newSourceAmount.clear();
                        });
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please fill up all fields")));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Add Source of Funds",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
