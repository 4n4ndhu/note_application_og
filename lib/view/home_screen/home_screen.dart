import 'package:flutter/material.dart';

import 'package:note_application_og/controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await HomeScreenController.getAllEmployee();
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Notes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              _customeBottomSheet(
                context,
              );
            },
          ),
          body: ListView.separated(
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      _customeBottomSheet(context,
                          isEdit: true,
                          name: HomeScreenController.employeeDataList[index]
                              ["note"],
                          id: HomeScreenController.employeeDataList[index]
                              ["id"]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                HomeScreenController.employeeDataList[index]
                                    ["note"],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await HomeScreenController.removeEmployee(
                                    HomeScreenController.employeeDataList[index]
                                        ["id"]);
                                setState(() {});
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: HomeScreenController.employeeDataList.length)),
    );
  }

  Future<dynamic> _customeBottomSheet(BuildContext context,
      {String? name, int? id, bool isEdit = false}) {
    TextEditingController nameController =
        TextEditingController(text: name ?? "");

    if (isEdit = true) {
      nameController.text == name;
    }

    return showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 25),
              TextFormField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: "Name",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xff1a75d2),
                      )),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (id == null) {
                              await HomeScreenController.addEmployee(
                                note: nameController.text,
                              );
                              setState(() {});
                              Navigator.pop(context);
                            } else {
                              await HomeScreenController.updateEmployee(
                                  nameController.text, id);
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Save"))),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}