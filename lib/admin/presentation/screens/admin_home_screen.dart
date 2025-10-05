import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/screens/login_screen.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/presentation/controllers/category/category_admin_bloc.dart';
import 'package:quiz_app/admin/presentation/controllers/quiz/quiz_admin_bloc.dart';
import 'package:quiz_app/admin/presentation/controllers/statistics/statistics_admin_bloc.dart';
import 'package:quiz_app/admin/presentation/screens/manage_categories_screen.dart';
import 'package:quiz_app/admin/presentation/screens/manage_quizzes_screen.dart';
import 'package:quiz_app/admin/presentation/widgets/category_statistics_card.dart';
import 'package:quiz_app/admin/presentation/widgets/dashboard_card.dart';
import 'package:quiz_app/admin/presentation/widgets/recent_activity_card.dart';
import 'package:quiz_app/admin/presentation/widgets/state_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen(
      {super.key, required this.username, required this.userId});
  final String userId;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: BlocBuilder<StatisticsAdminBloc, StatisticsAdminState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              );
            }
            if (state.status == Status.error) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome $username',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s your quiz appllication overview',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _buildStateCard(state),
                  const SizedBox(height: 20),
                  CategoryStatisticsCard(data: state.categories),
                  const SizedBox(height: 20),
                  RecentActivityCard(data: state.latestQuiz),
                  const SizedBox(height: 20),
                  _buildQuizActions(context),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildStateCard(StatisticsAdminState state) {
    return Row(
      children: [
        Expanded(
          child: StateCard(
            title: 'Total Categories',
            value: state.totalCategory.toString(),
            icon: Icons.category_rounded,
            color: AppTheme.primaryColor,
          ),
        ),
        Expanded(
          child: StateCard(
            title: 'Total Quizzes',
            value: state.totalQuiz.toString(),
            icon: Icons.quiz_rounded,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.speed_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quiz Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildQuizActionGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      childAspectRatio: 0.8,
      crossAxisSpacing: 10,
      children: [
        DashboardCard(
          title: 'Manage Quizzes',
          icon: Icons.quiz_rounded,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                context.read<QuizAdminBloc>().add(GetAllQuizzesEvent(userId));

                return ManageQuizzesScreen();
              }),
            ).then(
              (value) => context
                  .read<StatisticsAdminBloc>()
                  .add(GetStatisticsDataEvent()),
            );
          },
        ),
        DashboardCard(
          title: 'Manage Categories',
          icon: Icons.category_rounded,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                context.read<CategoryAdminBloc>().add(GetAllCategoriesEvent());

                return ManageCategoriesScreen();
              }),
            ).then(
              (value) => context
                  .read<StatisticsAdminBloc>()
                  .add(GetStatisticsDataEvent()),
            );
          },
        ),
      ],
    );
  }
}
