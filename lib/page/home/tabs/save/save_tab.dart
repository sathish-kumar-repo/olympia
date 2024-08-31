import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:olympia/services/save_firestore.dart';
import 'package:olympia/utils/app_color.dart';
import 'package:olympia/widgets/my_text_field.dart';
import '../../../../model/my_save.dart';
import '../../../../widgets/place_holder.dart';
import 'widget/my_save_tile.dart';

class Save extends StatefulWidget {
  const Save({super.key});

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
  final SaveFirestoreService firestoreService = SaveFirestoreService();
  final _searchController = TextEditingController();
  String query = '';
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  Widget _buildListView() {
    return StreamBuilder(
      stream: firestoreService.getSaveStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MySave> saveLst = _filterSave(snapshot.data!);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                child: MyTextField(
                  controller: _searchController,
                  placeholder: 'Search here...',
                  isBorder: false,
                  icon: CupertinoIcons.search,
                  onChanged: (text) {
                    setState(() {
                      query = text;
                    });
                  },
                ),
              ),
              saveLst.isEmpty && query.isNotEmpty
                  ? const Expanded(child: PlaceHolder('No result found'))
                  : saveLst.isEmpty
                      ? const Expanded(child: PlaceHolder('Nothing save'))
                      : _buildListViewItems(saveLst),
            ],
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(
            radius: 25,
            color: AppColor.accent,
          ),
        );
      },
    );
  }

  List<MySave> _filterSave(List<MySave> saveLst) {
    if (query == '') {
      return saveLst;
    } else {
      return saveLst.where((save) {
        return save.title
            .toLowerCase()
            .trim()
            .contains(query.toLowerCase().trim());
      }).toList();
    }
  }

  Widget _buildListViewItems(List<MySave> saveLst) {
    return Expanded(
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
          itemCount: saveLst.length,
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            position: index,
            child: FadeInAnimation(
              delay: const Duration(milliseconds: 275),
              child: MySaveTile(
                save: saveLst[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
