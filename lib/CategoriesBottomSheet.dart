import 'package:chat_app_c4_online/utils.dart';
import 'package:flutter/material.dart';

class CategoriesBottomSheet extends StatelessWidget {
  Function onCategorySelectedCallBack;

  CategoriesBottomSheet(this.onCategorySelectedCallBack);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (buildContext, index) {
        return InkWell(
          onTap: () {
            onCategorySelectedCallBack(categories[index]);
            Navigator.pop(buildContext);
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(
                  categories[index].image,
                  width: 24,
                  height: 24,
                ),
                Text(categories[index].name),
              ],
            ),
          ),
        );
      },
      itemCount: categories.length,
    );
  }
}
