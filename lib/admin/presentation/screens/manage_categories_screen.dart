import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/domain/entities/category_admin.dart';
import 'package:quiz_app/admin/presentation/controllers/category/category_admin_bloc.dart';
import 'package:quiz_app/admin/presentation/controllers/quiz/quiz_admin_bloc.dart';
import 'package:quiz_app/admin/presentation/controllers/statistics/statistics_admin_bloc.dart';
import 'package:quiz_app/admin/presentation/screens/add_category_screen.dart';
import 'package:quiz_app/admin/presentation/screens/manage_quizzes_screen.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            context.read<StatisticsAdminBloc>().add(GetStatisticsDataEvent());
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: AppTheme.primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddCategoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoryAdminBloc, CategoryAdminState>(
        builder: (ctx, state) {
          if (state.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (state.status == Status.error) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state.categories.isEmpty) {
            return _buildEmptyCategories(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length,
            itemBuilder: (ctx, index) {
              final category = state.categories[index];
              return _buildCategoryItem(context, category);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyCategories(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            color: AppTheme.textSecondaryColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No categories found',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCategoryScreen(),
              ));
            },
            child: Text('Add Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryAdmin category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.category_outlined,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          category.description,
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        trailing: _buildPopupMenu(context, category),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                context.read<QuizAdminBloc>().add(
                      GetQuizzesByCategoryIdEvent(
                        category.id,
                        categories:
                            context.read<CategoryAdminBloc>().state.categories,
                      ),
                    );
                return ManageQuizzesScreen(category: category);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, CategoryAdmin category) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(
              Icons.edit,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            title: Text('Edit'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              Icons.delete,
              size: 18,
              color: Colors.red,
            ),
            title: Text('Delete'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      onSelected: (value) {
        _handleCategoryAction(context, value, category);
      },
    );
  }

  void _handleCategoryAction(
      BuildContext context, String action, CategoryAdmin category) async {
    if (action == 'edit') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddCategoryScreen(category: category),
      ));
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        context.read<CategoryAdminBloc>().add(DeleteCategoryEvent(category));
      }
    }
  }
}
