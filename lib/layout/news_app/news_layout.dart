import 'package:flutter/material.dart';
import 'package:todo_app/layout/news_app/cubit/cubit.dart';

class NewsLayout extends StatelessWidget {
  final NewsCubit cubit;

  const NewsLayout(this.cubit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 35.0,
        ),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: cubit.bottomItems,
        currentIndex: cubit.currentIndex,
        onTap: (index) {
          cubit.changeIndex(index);
        },
      ),
      body: cubit.screens[cubit.currentIndex],
    );
  }
}
