import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/admin/presentation/widgets/question_card.dart';
import 'package:quiz_app/core/functions/functions.dart';
import 'package:quiz_app/core/service/service_locator.dart';

import 'package:quiz_app/core/theme/app_theme.dart';
import 'package:quiz_app/core/utils/status_enum.dart';
import 'package:quiz_app/admin/domain/entities/question_admin.dart';
import 'package:quiz_app/admin/domain/entities/quiz_admin.dart';
import 'package:quiz_app/admin/domain/usecase/quiz/add_quiz.dart';
import 'package:quiz_app/admin/presentation/controllers/question/question_admin_bloc.dart';

import 'package:quiz_app/admin/presentation/controllers/quiz/quiz_admin_bloc.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key, this.quiz, this.categoryId});
  final QuizAdmin? quiz;
  final int? categoryId;

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeLimitController = TextEditingController();

  int? selectedCategory;
  late int lengthQuestions;
  List<QuestionAdmin> deletedQuestions = [];

  void _addQuestion() {
    context.read<QuestionAdminBloc>().add(
          AddQuestionEvent(
            QuestionFromItem(
              questionController: TextEditingController(),
              optionsControllers: List.generate(
                4,
                (_) => TextEditingController(),
              ),
              correctOptionIndex: 0,
            ),
          ),
        );
  }

  void _removeQuestion(int index) {
    context.read<QuestionAdminBloc>().add(RemoveQuestionEvent(index));
    if (widget.quiz != null && index < lengthQuestions) {
      final question = widget.quiz!.questions[index];
      deletedQuestions.add(question);
      lengthQuestions--;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || selectedCategory == null) {
      if (selectedCategory == null) {
        Functions.showSnackBar(
          context,
          title: 'Failure',
          content: 'Must Select Category',
          icon: Icons.error_outlined,
          color: Colors.red,
        );
      }
      return;
    }
    final List<QuestionParameter> questions = [];
    final state = context.read<QuestionAdminBloc>().state.questions;

    for (final question in state) {
      final options = question.optionsControllers
          .map((option) => AnswerParameter(option.text))
          .toList();
      questions.add(
        QuestionParameter(
          question.questionController.text,
          List<AnswerParameter>.from(options),
          question.correctOptionIndex,
        ),
      );
    }
    final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
    final quiz = QuizParameters(
      userId: userId!,
      title: _titleController.text,
      categoryId: selectedCategory!,
      timeLimit: int.parse(_timeLimitController.text),
      questions: List<QuestionParameter>.from(questions),
    );

    context.read<QuizAdminBloc>().add(AddQuizEvent(quiz));

    Functions.showSnackBar(
      context,
      title: 'success',
      content: 'Quiz added successfully',
      icon: Icons.check,
      color: Colors.green,
    );

    Navigator.of(context).pop();
  }

  void _update() async {
    if (!_formKey.currentState!.validate() || selectedCategory == null) {
      if (selectedCategory == null) {
        Functions.showSnackBar(
          context,
          title: 'Failure',
          content: 'Must Select Category',
          icon: Icons.error_outlined,
          color: Colors.red,
        );
      }
      return;
    }

    for (final ques in deletedQuestions) {
      widget.quiz!.questions.remove(ques);
      context.read<QuestionAdminBloc>().add(DeleteQuestionEvent(ques.id));
    }
    final List<QuestionParameter> questions = [];
    final state = context.read<QuestionAdminBloc>().state.questions;

    for (int i = 0; i < state.length; i++) {
      final options = state[i]
          .optionsControllers
          .map((option) => AnswerParameter(option.text))
          .toList();
      questions.add(
        QuestionParameter(
          id: i < widget.quiz!.questions.length
              ? widget.quiz!.questions[i].id
              : null,
          state[i].questionController.text,
          List<AnswerParameter>.from(options),
          state[i].correctOptionIndex,
        ),
      );
    }
    final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
    final quiz = QuizParameters(
      userId: userId!,
      id: widget.quiz!.id,
      title: _titleController.text,
      categoryId: selectedCategory!,
      timeLimit: int.parse(_timeLimitController.text),
      questions: List<QuestionParameter>.from(questions),
    );

    context.read<QuizAdminBloc>().add(UpdateQuizEvent(quiz));

    Functions.showSnackBar(
      context,
      title: 'Success',
      content: 'Quiz updated successfully',
      icon: Icons.check,
      color: Colors.green,
    );
    Navigator.of(context).pop();
  }

  void initialQuiz() {
    final List<QuestionFromItem> questions = [];
    _titleController.text = widget.quiz!.title;
    _timeLimitController.text = widget.quiz!.timeLimit.toString();
    selectedCategory = widget.quiz!.categoryId;

    for (final question in widget.quiz!.questions) {
      questions.add(QuestionFromItem(
        questionController: TextEditingController(text: question.title),
        optionsControllers: List.generate(
          4,
          (index) => TextEditingController(
            text: question.options[index].text,
          ),
        ),
        correctOptionIndex: question.correctOptionIndex,
      ));
    }

    context.read<QuestionAdminBloc>().add(InitialQuestoinsEvent(questions));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeLimitController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.quiz != null) {
      initialQuiz();
      lengthQuestions = widget.quiz!.questions.length;
    } else {
      context.read<QuestionAdminBloc>().add(ResetQuestoinsEvent());
    }
    if (widget.categoryId != null) {
      selectedCategory = widget.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz != null ? 'Edit Quiz' : 'Add Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed:
                context.read<QuizAdminBloc>().state.status == Status.loading
                    ? null
                    : widget.quiz != null
                        ? _update
                        : _save,
            icon: context.read<QuizAdminBloc>().state.status == Status.loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Icon(
                    Icons.save,
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text(
              'Quiz Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Quiz Title',
                hintText: 'Enter quiz title',
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                hintStyle: TextStyle(fontSize: 13),
                prefixIcon: Icon(
                  Icons.title_rounded,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quiz title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                border: OutlineInputBorder(),
                labelText: 'Category',
                hintText: 'Select Category',
                prefixIcon: Icon(
                  Icons.category_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              value: selectedCategory,
              items: context
                  .read<QuizAdminBloc>()
                  .state
                  .categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _timeLimitController,
              decoration: InputDecoration(
                labelText: 'Time Limit [in minutes]',
                hintText: 'Enter time limit',
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                hintStyle: TextStyle(fontSize: 13),
                prefixIcon: Icon(
                  Icons.timer_rounded,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter time limit';
                }
                final number = int.tryParse(value);
                if (number == null || number < 1) {
                  return 'time must be more than minute';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  label: Text(
                    'Add Question',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocSelector<QuestionAdminBloc, QuestionAdminState,
                List<QuestionFromItem>>(
              selector: (state) {
                return state.questions;
              },
              builder: (context, state) {
                return Column(
                  children: state.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final question = entry.value;
                      return QuestionCard(
                        question: question,
                        index: index,
                        canRemove: state.length > 1,
                        onRemove: () => _removeQuestion(index),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
