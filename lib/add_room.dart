import 'package:chat_app_c4_online/CategoriesBottomSheet.dart';
import 'package:chat_app_c4_online/data/firestore_utils.dart';
import 'package:chat_app_c4_online/data/room.dart';
import 'package:chat_app_c4_online/utils.dart';
import 'package:flutter/material.dart';

class AddRoomScreen extends StatefulWidget {
  static const String routeName = 'Add-room';

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  Category selectedCateogry = categories[0];
  var formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  var ids = [Category.sportsId, Category.moviesId, Category.musicId];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/pattern.png'))),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Chat Room'),
          ),
          body: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(24),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey, offset: Offset(4, 4))
                ]),
            child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create new Room',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Image.asset(
                      'assets/images/group_logo.png',
                      height: 80,
                      fit: BoxFit.fitHeight,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Room Name'),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'please enter room name';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        name = text;
                      },
                    ),
                    TextFormField(
                      minLines: 4,
                      maxLines: 4,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'please enter room description';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        description = text;
                      },
                    ),
                    InkWell(
                      onTap: () => showCategoriesBottomSheet(),
                      child: Row(
                        children: [
                          Image.asset(
                            selectedCateogry.image,
                            width: 32,
                            height: 32,
                          ),
                          Text(selectedCateogry.name)
                        ],
                      ),
                    ),

                    ElevatedButton(
                        onPressed: () {
                          createRoom();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Create'),
                        )),
                    // DropdownButton<Category>(
                    //  // value:ids[0] ,
                    //     items: categories
                    //         .map<DropdownMenuItem<Category>>((category) {
                    //          // var category = Category.fromId(categoryId);
                    //   return DropdownMenuItem<Category>(
                    //     value: category,
                    //       child: Row(
                    //     children: [
                    //       // Image.asset(
                    //       //   category.image,
                    //       //   width: 48,
                    //       //   height: 48,
                    //       // ),
                    //       Text(category.name)
                    //     ],
                    //   ));
                    // }).toList())
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void showCategoriesBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (buildContext) {
          return CategoriesBottomSheet(onCategorySelected);
        });
  }

  void onCategorySelected(Category category) {
    this.selectedCateogry = category;
    setState(() {});
  }

  void createRoom() async {
    if (formKey.currentState!.validate()) {
      try {
        showLoading(context);
        var res = await addRoomToFireStore(Room(
            id: '',
            name: name,
            description: description,
            categoryId: selectedCateogry.id));
        hideLoading(context);
        Navigator.pop(context);
      } on Exception catch (e) {
        showMessage(e.toString(), context);
      }
    }
  }
}
