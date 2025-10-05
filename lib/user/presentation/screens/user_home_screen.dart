import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/screens/login_screen.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/user/presentation/screens/category_details_screen.dart';
import 'package:quiz_app/user/user.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: true,
            centerTitle: false,
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
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
            title: Text(
              'Smart Quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: kToolbarHeight),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $username',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'lets test your knowledge today!',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(25),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search Categories...',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              onChanged: (value) {
                                context
                                    .read<CategoryUserBloc>()
                                    .add(SearchForCategoriesEvent(value));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              height: 40,
              child: BlocSelector<CategoryUserBloc, CategoryUserState,
                  List<FilterCategory>>(
                selector: (state) {
                  return state.filterCategories;
                },
                builder: (context, state) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final filter = state[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            filter.name,
                            style: TextStyle(
                              color: filter.isSelected
                                  ? Colors.white
                                  : AppTheme.textPrimaryColor,
                            ),
                          ),
                          selectedColor: AppTheme.primaryColor,
                          selected: filter.isSelected,
                          backgroundColor: Colors.white,
                          onSelected: (value) {
                            if (value) {
                              // TODO:: Not Complete
                              context.read<CategoryUserBloc>()
                                ..add(SelectFilterCategoryEvent(filter.id))
                                ..add(FilterCategoriesEvent(filter.id));
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          BlocBuilder<CategoryUserBloc, CategoryUserState>(
            buildWhen: (previous, current) =>
                previous.categories != current.categories ||
                previous.status != current.status,
            builder: (context, state) {
              if (state.status == Status.loading) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }
              if (state.status == Status.error) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              }
              if (state.categories.isEmpty) {
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category,
                        size: 50,
                        color: AppTheme.primaryColor,
                      ),
                      Text(
                        'No categories found',
                        style: TextStyle(color: AppTheme.textSecondaryColor),
                      ),
                    ],
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: state.filterCategories.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No categories found',
                            style:
                                TextStyle(color: AppTheme.textSecondaryColor),
                          ),
                        ),
                      )
                    : SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          childCount: state.categories.length,
                          (context, index) => _buildCategoryCard(
                              context, state.categories[index], index),
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, CategoryUser category, int index) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return BlocProvider(
              create: (context) => getIt<QuizUserBloc>()
                ..add(FetchQuizzesByCategoryIdEvent(category.id)),
              child: CategoryDetailsScreen(category: category),
            );
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.quiz,
                  size: 30,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    )
        .slideUp(
          delay: Duration(milliseconds: 200 * index),
          duration: const Duration(milliseconds: 300),
        )
        .fadeIn();
  }
}
