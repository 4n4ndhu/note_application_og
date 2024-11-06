import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:note_application_og/controller/home_screen_controller.dart';
import 'package:note_application_og/utils/color_constants.dart';

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
          itemBuilder: (context, index) {
            // Get the timestamp from employeeDataList
            String timestamp =
                HomeScreenController.employeeDataList[index]["timestamp"];
            DateTime dateTime = DateTime.parse(timestamp)
                .toLocal(); // Convert UTC to local time

            // Format the time (customize the format as needed)
            String formattedTime = DateFormat('hh:mm a').format(dateTime);

            return InkWell(
              onTap: () async {
                _customeBottomSheet(context,
                    isEdit: true,
                    name: HomeScreenController.employeeDataList[index]["note"],
                    id: HomeScreenController.employeeDataList[index]["id"]);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 120,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Text(formattedTime), // Display the formatted timestamp
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: HomeScreenController.employeeDataList.length,
        ),
      ),
    );
  }

  Future<dynamic> _customeBottomSheet(BuildContext context,
      {String? name, int? id, bool isEdit = false}) {
    TextEditingController nameController =
        TextEditingController(text: name ?? "");

    if (isEdit) {
      nameController.text == name;
    }

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black,
      context: context,
      builder: (context) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 25),
                Expanded(
                  child: TextField(
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    controller: nameController,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      hintText: "Add a note",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String timestamp = DateTime.now()
                              .toUtc()
                              .toString(); // Store UTC time
                          if (id == null) {
                            await HomeScreenController.addEmployee(
                              note: nameController.text,
                              timestamp: timestamp,
                            );
                            setState(() {});
                            Navigator.pop(context);
                          } else {
                            await HomeScreenController.updateEmployee(
                              nameController.text,
                              id,
                            );
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
