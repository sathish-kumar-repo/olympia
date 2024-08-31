import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olympia/page/add_section/add_section_page.dart';
import 'package:olympia/page/home/tabs/save/save_tab.dart';
import 'package:olympia/page/home/tabs/to_do/to_do_tab.dart';
import 'package:olympia/page/my_editor/my_editor_page.dart';
import 'package:olympia/services/save_firestore.dart';
import 'package:olympia/services/to_do_firestore.dart';

import 'package:olympia/utils/app_color.dart';
import 'package:olympia/utils/pop_up_text_field.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../utils/helper_fn.dart';
import '../../widgets/my_app_bar.dart';
import '../add_challenge/add_challenge_page.dart';
import 'tabs/challenge/challenge_tab.dart';

import 'tabs/training/training_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTapIndex = 0;
  int _selectedWeekDayIndex = 0;
  final _saveTitleController = TextEditingController();
  final _toDoController = TextEditingController();

  @override
  void dispose() {
    _saveTitleController.dispose();
    _toDoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  MyAppBar _buildAppBar() {
    return MyAppBar(
      title: 'My ${getAppName(_selectedTapIndex)}',
      trailing: _buildBtn(),
      leading: Icon(
        getAppIcon(_selectedTapIndex),
        size: 25,
        color: Colors.grey,
      ),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: AnimatedSwitcherPlus.zoomOut(
        duration: const Duration(milliseconds: 500),
        child: _getBody(),
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedTapIndex) {
      case 0:
        return Training(
          selectedWeekDay: (newIndex) {
            _selectedWeekDayIndex = newIndex;
          },
        );
      case 1:
        return const Save();
      case 2:
        return const ToDo();
      default:
        return const Challenge();
    }
  }

  SalomonBottomBar _buildNavigationBar() {
    return SalomonBottomBar(
      selectedItemColor: AppColor.accent,
      currentIndex: _selectedTapIndex,
      backgroundColor: AppColor.bottomBar,
      onTap: (value) => setState(() => _selectedTapIndex = value),
      items: List.generate(
        4,
        (index) => SalomonBottomBarItem(
          icon: Icon(getAppIcon(index)),
          title: Text(
            getAppName(index),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBtn() {
    return GestureDetector(
      onTap: _onAdd,
      child: const Icon(
        CupertinoIcons.add,
        color: AppColor.accent,
        size: 30,
      ),
    );
  }

  void _onAdd() {
    if (_selectedTapIndex == 0) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => AddSectionPage(
            selectedWeekDayIndex: _selectedWeekDayIndex,
          ),
        ),
      );
    } else if (_selectedTapIndex == 1) {
      popUpTextField(
        context,
        textController: _saveTitleController,
        title: getDate(DateTime.now()),
        hintText: 'Your title',
        onSaveText: 'Create',
        onSave: (title) {
          Navigator.of(context)
              .push(
            CupertinoPageRoute(
              builder: (context) => MyTextEditor(
                title: title,
              ),
            ),
          )
              .then((save) {
            SaveFirestoreService().addSave(
              title: title,
              save: save,
            );
          });
        },
      );
    } else if (_selectedTapIndex == 2) {
      popUpTextField(
        context,
        textController: _toDoController,
        title: 'My To Do',
        hintText: 'Type Here..',
        onSaveText: 'Create',
        onSave: (title) {
          ToDoFirestoreService().addToDo(title: title);
        },
      );
    } else if (_selectedTapIndex == 3) {
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => const AddChallengePage()),
      );
    } else {
      throw ('Selected Tap Index is not true');
    }
  }
}
