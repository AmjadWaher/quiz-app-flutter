import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/admin/admin.dart';
import 'package:quiz_app/admin/presentation/screens/admin_home_screen.dart';
import 'package:quiz_app/auth/domain/entities/user.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/password_visibility/password_visibility_cubit.dart';
import 'package:quiz_app/auth/presentation/screens/login_screen.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/functions/hide_keyboard.dart';
import 'package:quiz_app/core/service/app_links_manager.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/splash_screen.dart';
import 'package:quiz_app/user/presentation/screens/user_home_screen.dart';
import 'package:quiz_app/user/user.dart';

import 'core/functions/ticker.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator().init();
  await AppLinksManager().initAppLinks();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<PasswordVisibilityCubit>(),
          ),
          BlocProvider(
            create: (context) =>
                getIt<StatisticsAdminBloc>()..add(GetStatisticsDataEvent()),
          ),
          BlocProvider(
            create: (context) => getIt<CategoryAdminBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<QuizAdminBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<QuestionAdminBloc>(),
          ),
          BlocProvider(
            create: (context) =>
                getIt<CategoryUserBloc>()..add(FetchAllCategoriesEvent()),
          ),
          BlocProvider(create: (context) => getIt<QuestionUserBloc>()),
          BlocProvider(create: (context) => TimerBloc(ticker: Ticker())),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Smart Quiz',
          theme: AppTheme.theme,
          home: const AuthGate(),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthError) {
          Functions.showSnackBar(
            context,
            title: 'Error',
            content: state.error,
            icon: Icons.error_outline,
            color: Colors.red,
          );
        }
        if (state is Authenticated) {
          log(state.user.role.name);
          if (state.user.role == Role.teacher) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AdminHomeScreen(
                    userId: state.user.id, username: state.user.name),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserHomeScreen(username: state.user.name),
              ),
            );
          }
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      child: const SplashScreen(),
    );
  }
}
