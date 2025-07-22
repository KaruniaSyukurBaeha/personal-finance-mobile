part of 'dashboard_cubit.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final List<Transaction> transactions;
  DashboardLoaded({required this.transactions});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError({required this.message});
}

class DashboardLoading extends DashboardState {}
