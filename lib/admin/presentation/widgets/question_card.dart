// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quiz_app/admin/presentation/controllers/question/question_admin_bloc.dart';
import 'package:quiz_app/core/theme/app_theme.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });
  final QuestionFromItem question;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
                if(canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: question.questionController,
              decoration: InputDecoration(
                labelText: 'Question Title',
                hintText: 'Enter question',
                hintStyle: TextStyle(fontSize: 13),
                fillColor: AppTheme.backgroundColor,
                prefixIcon: Icon(
                  Icons.question_answer_rounded,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter question';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            ...question.optionsControllers.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final controller = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Radio<int>(
                      value: optionIndex,
                      groupValue: question.correctOptionIndex,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        context.read<QuestionAdminBloc>().add(
                              SelectedCorrectOptionEvent(
                                index,
                                optionIndex,
                              ),
                            );
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Option ${optionIndex + 1}',
                          hintText: 'Enter option',
                          hintStyle: TextStyle(fontSize: 13),
                          fillColor: AppTheme.backgroundColor,
                          prefixIcon: Icon(
                            Icons.question_answer_rounded,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter question';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
