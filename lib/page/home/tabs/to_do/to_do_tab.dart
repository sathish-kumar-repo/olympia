import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:olympia/model/my_to_do.dart';
import 'package:olympia/services/to_do_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/place_holder.dart';
import 'widget/my_to_do_tile.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final firestoreService = ToDoFirestoreService();
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildToggle(),
        _buildListView(),
      ],
    );
  }

  Widget _buildToggle() {
    double width = 110;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ToggleSwitch(
          animate: true,
          radiusStyle: true,
          cornerRadius: 50.0,
          animationDuration: 400,
          dividerColor: Colors.transparent,
          initialLabelIndex: _selectedIndex,
          activeBgColor: const [
            AppColor.accent,
          ],
          customWidths: [width, width],
          minHeight: 50,
          totalSwitches: 2,
          activeFgColor: Colors.white,
          inactiveFgColor: Colors.white,
          inactiveBgColor: Theme.of(context).scaffoldBackgroundColor,
          labels: const [
            'Pending',
            'Finished',
          ],
          onToggle: (index) {
            setState(() {
              _selectedIndex = index ?? 0;
            });
          },
        ),
      ),
    );
  }

  Expanded _buildListView() {
    return Expanded(
      child: StreamBuilder(
        stream: firestoreService.getToDoStream(_selectedIndex != 0),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 25,
                color: AppColor.accent,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong!'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data'),
            );
          } else {
            final List<MyToDo> toDoLst = snapshot.data!;

            return toDoLst.isEmpty
                ? PlaceHolder(
                    _selectedIndex == 0
                        ? 'Nothing to do...'
                        : 'Nothing finished...',
                  )
                : _buildListViewItems(toDoLst);
          }
        },
      ),
    );
  }

  AnimationLimiter _buildListViewItems(List<MyToDo> toDoLst) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 50),
        itemCount: toDoLst.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          child: FadeInAnimation(
            delay: const Duration(milliseconds: 275),
            child: MyToDoTile(
              toDo: toDoLst[index],
            ),
          ),
        ),
      ),
    );
  }
}
