part of 'timer_bloc.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

final class TimerStarted extends TimerEvent {
  final int duration;

  const TimerStarted({required this.duration});
}

final class _TimerTicked extends TimerEvent {
  final int duration;

  const _TimerTicked({required this.duration});
}
