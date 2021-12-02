import 'package:chat_app_c4_online/add_room.dart';
import 'package:chat_app_c4_online/data/room.dart';
import 'package:chat_app_c4_online/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'home';

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
            title: Text('Route Chat App'),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddRoomScreen.routeName);
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(12),
            child: StreamBuilder<QuerySnapshot<Room>>(
              stream: Room.withConverter().snapshots(),
              builder: (builder, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var roomsList =
                    snapshot.data?.docs.map((e) => e.data()).toList();
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: .9),
                  itemBuilder: (buildContext, index) {
                    return RoomGridItem(roomsList!.elementAt(index));
                  },
                  itemCount: roomsList?.length ?? 0,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class RoomGridItem extends StatelessWidget {
  Room room;

  RoomGridItem(this.room);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black45, offset: Offset(4, 1))]),
      child: Column(
        children: [
          Image.asset(Category.fromId(room.categoryId).image),
          Text(
            room.name,
            maxLines: 1,
          )
        ],
      ),
    );
  }
}
