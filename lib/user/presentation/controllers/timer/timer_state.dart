part of 'timer_bloc.dart';

sealed class TimerState extends Equatable {
  const TimerState(this.duration);
  final int duration;

  @override
  List<Object> get props => [duration];
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}
