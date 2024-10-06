import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smit_task_todo_app/auth/sign_in_screen.dart';
import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_clear_button_widget.dart';
import 'package:smit_task_todo_app/widgets/text_form_field_widget.dart';
import 'package:smit_task_todo_app/widgets/update_to_do_widget.dart';

import '../widgets/add_new_to_do_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> allToDo = [];
  bool loading = false;

  // late Query filteredToDo;

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference dbTodo = FirebaseDatabase.instance.ref('todo');
  DatabaseReference dbUser = FirebaseDatabase.instance.ref('users');

  TextEditingController searchController = TextEditingController();
  late String userName = '';

  @override
  void initState() {
    super.initState();
    loadToDo();
    getName();
    // filteredToDo = dbTodo.orderByChild('uid').equalTo(auth.currentUser!.uid);
  }

  void getName() async {
    DataSnapshot snapshot = await dbUser.child(auth.currentUser!.uid).get();
    print(snapshot.child('name').value.toString());

    userName = snapshot.child('name').value.toString();
  }

  Future<void> loadToDo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      allToDo = prefs.getStringList('savedToDo') ?? [];
    });
  }

  Future<void> saveToDo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedToDo', allToDo);
  }

  void addNewToDo(String toDo) {
    if (toDo.isNotEmpty) {
      setState(() {
        allToDo.add(toDo);
      });
    }
    saveToDo();
  }

  void removeToDo(int index) {
    setState(() {
      allToDo.removeAt(index);
    });
    saveToDo();
  }

  void signOut(context) {
    setState(() {
      loading = true;
    });
    auth.signOut().then((value) {
      Toasts().success('Signed Out Successfully');
      loading != loading;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SignInScreen();
          },
        ),
      );
    }).onError((error, value) {
      loading = false;
      Toasts().fail(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          auth.currentUser != null ? userName : 'Welcome',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          SizedBox(
            height: 40.h,
            width: 200.w,
            child: TextFormFieldWidget(
                onChange: (value) {
                  setState(() {});
                },
                fieldText: 'Search',
                hintText: 'search',
                validate: (search) {
                  return null;
                },
                textController: searchController,
                lastIcon:
                    TextClearButtonWidget(textController: searchController)),
          ),
          loading
              ? const CircularProgressIndicator(
                  color: Colors.deepPurple,
                )
              : IconButton(
                  onPressed: () {
                    signOut(context);
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 25.r,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddNewToDoWidget(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: dbTodo,
                itemBuilder: (context, snapshot, animations, index) {
                  if (snapshot
                      .child('title')
                      .value
                      .toString()
                      .contains(searchController.text.toString())) {
                    return Padding(
                      padding: const EdgeInsets.all(10).r,
                      child: ListTile(
                        tileColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        titleTextStyle:
                            TextStyle(fontSize: 20.sp, color: Colors.black54),
                        subtitleTextStyle:
                            TextStyle(fontSize: 15.sp, color: Colors.black26),
                        leading: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: UpdateToDoWidget(
                                        id: snapshot
                                            .child('id')
                                            .value
                                            .toString(),
                                        title: snapshot
                                            .child('title')
                                            .value
                                            .toString(),
                                        description: snapshot
                                            .child('description')
                                            .value
                                            .toString(),
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 20.r,
                            )),
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(10).r,
                          child: Text(
                              snapshot.child('description').value.toString()),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            dbTodo
                                .child(snapshot.child('id').value.toString())
                                .remove()
                                .then((value) {
                              Toasts().success('To-do deleted Successfully');
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 20.r,
                          ),
                        ),
                      ),
                    );
                  } else if (searchController.text.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(10).r,
                      child: ListTile(
                        tileColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        titleTextStyle:
                            TextStyle(fontSize: 20.sp, color: Colors.black54),
                        subtitleTextStyle:
                            TextStyle(fontSize: 15.sp, color: Colors.black26),
                        leading: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: UpdateToDoWidget(
                                        id: snapshot
                                            .child('id')
                                            .value
                                            .toString(),
                                        title: snapshot
                                            .child('title')
                                            .value
                                            .toString(),
                                        description: snapshot
                                            .child('description')
                                            .value
                                            .toString(),
                                      ),
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 20.r,
                            )),
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(10).r,
                          child: Text(
                              snapshot.child('description').value.toString()),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            dbTodo
                                .child(snapshot.child('id').value.toString())
                                .remove()
                                .then((value) {
                              Toasts().success('To-do deleted Successfully');
                            });
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 20.r,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      // body: allToDo.isNotEmpty
      // ? ListView.builder(
      //     itemCount: allToDo.length,
      //     itemBuilder: (context, index) {
      //       return Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 10.w),
      //         child: Column(
      //           children: [
      //             Container(
      //               margin: EdgeInsets.symmetric(vertical: 5.h),
      //               width: double.infinity,
      //               decoration: BoxDecoration(
      //                   color: Colors.black12,
      //                   borderRadius: BorderRadius.circular(10.r)),
      //               child: Row(
      //                 children: [
      //                   IconButton(
      //                       onPressed: () {
      //                         removeToDo(index);
      //                       },
      //                       icon: Icon(
      //                         Icons.close,
      //                         size: 20.r,
      //                       )),
      //                   Text(allToDo[index]),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     })
      // : Center(
      //     child: Text(
      //       textAlign: TextAlign.center,
      //       'No To-do added, kindly add one',
      //       style: TextStyle(fontSize: 20.sp),
      //     ),
      //   ),
    );
  }
}
