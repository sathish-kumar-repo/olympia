import 'package:share_plus/share_plus.dart';

void onShare(String txt) async {
  await Share.share(txt);
}
