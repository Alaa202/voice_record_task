part of 'record_cubit.dart';

@immutable
abstract class RecordState {}

class RecordInitial extends RecordState {}
class RecordOn extends RecordState {}
class ChangeRecord extends  RecordState {}
class RecordStopped extends RecordState {}
class ChangeVoicePlayerIndexState extends RecordState {}
class RecordError extends RecordState {}

class FilesLoading extends RecordState {}

class FilesLoaded extends RecordState {

}

class FilesPermisionNotGranted extends RecordState {}

class GetPath extends RecordState {}