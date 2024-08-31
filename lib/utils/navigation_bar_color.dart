import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_color.dart';

changeNavigationBarColor() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColor.theme,
      ),
    );
  });
}

normalNavigationBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColor.bottomBar,
    ),
  );
}
