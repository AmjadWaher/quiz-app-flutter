part of 'statistics_admin_bloc.dart';

sealed class StatisticsAdminEvent extends Equatable {
  const StatisticsAdminEvent();

  @override
  List<Object> get props => [];
}

class GetStatisticsDataEvent extends StatisticsAdminEvent {}
