part of 'post_fetch_cubit.dart';


abstract class PostFetchState {}

class PostFetchInitial extends PostFetchState {}

class PostLoaded extends PostFetchState {
  final List<Result> posts;
  PostLoaded({required this.posts});
}

class PostLoading extends PostFetchState {
  final List<Result> oldPost;
  PostLoading({required this.oldPost,this.isFirstFetch = false});
  final bool isFirstFetch;
}

class PostError extends PostFetchState {
  final String errorTitle;
  final String errorBody;
  PostError({required this.errorBody,required this.errorTitle});
}