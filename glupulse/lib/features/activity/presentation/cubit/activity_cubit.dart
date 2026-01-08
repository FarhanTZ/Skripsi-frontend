import 'package:bloc/bloc.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/usecases/add_activity_log.dart';
import 'package:glupulse/features/activity/domain/usecases/delete_activity_log.dart';
import 'package:glupulse/features/activity/domain/usecases/get_activity_logs.dart';
import 'package:glupulse/features/activity/domain/usecases/get_activity_types.dart';
import 'package:glupulse/features/activity/domain/usecases/update_activity_log.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final GetActivityTypes getActivityTypes;
  final GetActivityLogs getActivityLogs;
  final AddActivityLog addActivityLog;
  final UpdateActivityLog updateActivityLog;
  final DeleteActivityLog deleteActivityLog;

  List<ActivityLog> _allLogs = []; // Cache all logs

  ActivityCubit({
    required this.getActivityTypes,
    required this.getActivityLogs,
    required this.addActivityLog,
    required this.updateActivityLog,
    required this.deleteActivityLog,
  }) : super(ActivityInitial());

  Future<void> fetchActivityTypes() async {
    emit(ActivityLoading());
    final result = await getActivityTypes(NoParams());
    result.fold(
      (failure) => emit(ActivityError(failure.toString())),
      (types) => emit(ActivityTypesLoaded(activityTypes: types)),
    );
  }

  Future<void> fetchActivityLogs({String? filterCode}) async {
    emit(ActivityLoading());
    final result = await getActivityLogs(NoParams());
    result.fold(
      (failure) => emit(ActivityError(failure.toString())),
      (logs) {
        _allLogs = logs;
        if (filterCode != null) {
          final filtered = logs.where((log) => log.activityCode == filterCode).toList();
          emit(ActivityLogsLoaded(activityLogs: filtered, filterCode: filterCode));
        } else {
          emit(ActivityLogsLoaded(activityLogs: logs));
        }
      },
    );
  }

  void filterLogs(String code) {
    if (_allLogs.isNotEmpty) {
      final filtered = _allLogs.where((log) => log.activityCode == code).toList();
      emit(ActivityLogsLoaded(activityLogs: filtered, filterCode: code));
    }
  }

  Future<void> addLog(ActivityLog log) async {
    emit(ActivityLoading());
    final result = await addActivityLog(AddActivityLogParams(activityLog: log));
    result.fold(
      (failure) => emit(ActivityError(failure.toString())),
      (_) {
        emit(const ActivityOperationSuccess("Activity log added successfully"));
        // Refresh logs if needed, but usually UI handles navigation or refresh
      },
    );
  }

  Future<void> updateLog(ActivityLog log) async {
    emit(ActivityLoading());
    final result = await updateActivityLog(UpdateActivityLogParams(activityLog: log));
    result.fold(
      (failure) => emit(ActivityError(failure.toString())),
      (_) => emit(const ActivityOperationSuccess("Activity log updated successfully")),
    );
  }

  Future<void> deleteLog(String id) async {
    emit(ActivityLoading());
    final result = await deleteActivityLog(DeleteActivityLogParams(id: id));
    result.fold(
      (failure) => emit(ActivityError(failure.toString())),
      (_) => emit(const ActivityOperationSuccess("Activity log deleted successfully")),
    );
  }
}
