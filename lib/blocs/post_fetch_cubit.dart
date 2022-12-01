import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_understanding/blocs/post_repository.dart';

import '../models/pagination.dart';
part 'post_fetch_state.dart';

class PostFetchCubit extends Cubit<PostFetchState> {
  PostRepository postRepository;
  PostFetchCubit({required this.postRepository}) : super(PostFetchInitial());

  loadPosts({required int offset}) async{

    try{
      // if(state is PostLoading) return;
      final currentState = state;
      var oldPosts = <Result>[];
      if(currentState is PostLoaded) {
        oldPosts = currentState.posts;
      }
      emit(PostLoading(oldPost: oldPosts,isFirstFetch: offset == 0));
      Response response = await postRepository.fetchPost(offset: offset);
      if(response.statusCode == 200) {
        Pagination pagination = Pagination.fromJson(response.data);
        final posts = (state as PostLoading).oldPost;
        posts.addAll(pagination.results);
        emit(PostLoaded(posts: posts));
      }
    } on DioError catch(e){
      if(e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout || e.type == DioErrorType.sendTimeout) {
        emit(PostError(errorTitle: 'Request Timeout',
            errorBody: 'Unable to connect to the sever'));
      }
      else {
        emit(PostError(errorTitle: '${e.error} : ${e.response?.statusMessage}',errorBody: '${e.response}'));
      }
    }



  }


}
