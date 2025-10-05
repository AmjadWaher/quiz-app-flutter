import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/admin/admin.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/presentation/screens/add_quiz_screen.dart';

class ManageQuizzesScreen extends StatefulWidget {
  const ManageQuizzesScreen({super.key, this.category});
  final CategoryAdmin? category;

  @override
  State<ManageQuizzesScreen> createState() => _ManageQuizzesScreenState();
}

class _ManageQuizzesScreenState extends State<ManageQuizzesScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.contains(RegExp(r'[?=&%<>;#/\\]'))) {
      Functions.showSnackBar(
        context,
        title: 'Failure',
        content: 'Enter valid characters',
        icon: Icons.error_outline,
        color: Colors.red,
      );
      return;
    }
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(
      Duration(milliseconds: 300),
      () {
        context.read<QuizAdminBloc>().add(SearchQuizEvent(value));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Quizzes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
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
                  builder: (context) => AddQuizScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<QuizAdminBloc, QuizAdminState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.status == Status.loading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state.status == Status.error) {
            return Center(
              child: Text(state.message),
            );
          }

          return Column(
            children: [
              _buildSearchBar(),
              _buildCategoryDropdown(state),
              _buildQuizzesList(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: 'Search Quizzes',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildCategoryDropdown(QuizAdminState state) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          border: OutlineInputBorder(),
          hintText: 'Category',
        ),
        value: state.selectedCategoryId,
        items: [
          DropdownMenuItem(
            value: -1,
            child: Text('All Categories'),
          ),
          ...state.categories.map(
            (category) => DropdownMenuItem(
              value: category.id,
              child: Text(category.name),
            ),
          ),
        ],
        onChanged: (value) {
          context
              .read<QuizAdminBloc>()
              .add(GetQuizzesByCategoryIdEvent(value ?? -1));
        },
      ),
    );
  }

  Widget _buildQuizzesList(QuizAdminState state) {
    if (state.status == Status.loading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }
    if (state.quizzes.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 64,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No quizzes found',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 18,
                ),
              ),
              if (state.selectedCategoryId != -1) const SizedBox(height: 8),
              if (state.selectedCategoryId != -1)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddQuizScreen(
                          categoryId: state.selectedCategoryId,
                        ),
                      ),
                    );
                  },
                  child: Text('Add Quiz'),
                ),
            ],
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.quizzes.length,
        itemBuilder: (context, index) {
          final quiz = state.quizzes[index];
          return _buildQuizCard(context, quiz);
        },
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizAdmin quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 13,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.quiz,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            _buildQuizDetails(quiz),
          ],
        ),
        trailing: _buildQuizPopupMenu(context, quiz),
      ),
    );
  }

  Widget _buildQuizDetails(QuizAdmin quiz) {
    return Row(
      children: [
        Icon(
          Icons.question_answer_outlined,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          '${quiz.questions.length} ${quiz.questions.length > 1 ? 'questions' : 'question'}',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.timer_outlined,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        Text(
          '${quiz.timeLimit} mins',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  PopupMenuButton _buildQuizPopupMenu(BuildContext context, QuizAdmin quiz) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.edit,
              color: AppTheme.primaryColor,
              size: 18,
            ),
            title: Text('Edit'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.delete,
              size: 18,
              color: Colors.red,
            ),
            title: Text('Delete'),
          ),
        ),
      ],
      onSelected: (value) {
        _handleQuizAction(context, value, quiz);
      },
    );
  }

  void _handleQuizAction(
      BuildContext context, String action, QuizAdmin quiz) async {
    if (action == 'edit') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddQuizScreen(quiz: quiz),
      ));
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Quiz'),
          content: Text('Are you sure you want to delete this quiz?'),
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
        final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
        context.read<QuizAdminBloc>().add(
              DeleteQuizEvent(
                DeleteQuizParameters(
                  quizId: quiz.id,
                  userId: userId!,
                ),
              ),
            );
      }
    }
  }
}
