import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'features/personal/dashboard/views/providers/personal_bottom_nav_provider.dart';
import 'get_it.dart';

import 'features/personal/auth/signin/views/providers/signin_provider.dart';

final List<SingleChildWidget> appProviders = <SingleChildWidget>[
  // Add your providers here
  ChangeNotifierProvider<SigninProvider>.value(
      value: SigninProvider(locator(), locator())),

  ChangeNotifierProvider<PersonalBottomNavProvider>.value(
      value: PersonalBottomNavProvider()),
];
