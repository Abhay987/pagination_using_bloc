import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_understanding/blocs/post_fetch_cubit.dart';
import 'package:pagination_understanding/blocs/post_repository.dart';
import 'package:pagination_understanding/models/pagination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pagination Understanding',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(create: (context) => PostFetchCubit(postRepository: PostServices()),child: const HomePage(),),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScrollController scrollController = ScrollController();

   int offsetValue = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostFetchCubit>(context,listen: false).loadPosts(offset: offsetValue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollController.addListener(() {
      // if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      //   BlocProvider.of<PostFetchCubit>(context,listen: false).loadPosts(offset: offsetValue += 20);
      // }
      if(scrollController.position.atEdge) {
        if(scrollController.position.pixels !=0) {
          BlocProvider.of<PostFetchCubit>(context,listen: false).loadPosts(offset: offsetValue += 20);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Visibility(
      // visible: context.watch<PostFetchCubit>().state is PostLoading,
      //   child: const CircularProgressIndicator(color: Colors.blueGrey,),
      // ),
      body: BlocBuilder<PostFetchCubit,PostFetchState>(builder: (context,state){
        if(state is PostLoading && state.isFirstFetch) {
          return const Center(child: CircularProgressIndicator(color: Colors.black,),);
        }
        else if(state is PostError) {
         return Center(child: Text("${state.errorTitle}\n\n${state.errorBody}"),);
        }

        // else if(state is PostLoading) {
        //   return const CircularProgressIndicator(color: Colors.red,);
        // }
        // else if(state is PostLoaded) {
        //   return ListView.separated(controller: scrollController,
        //       itemBuilder: (context,index) {
        //     return ListTile(
        //       title: Text(state.posts[index].name),
        //       subtitle: Text(state.posts[index].url),
        //     );
        //   }, separatorBuilder: (context,index) => Divider(color: Colors.grey[400],), itemCount: state.posts.length);
        // }
        // else {
        //   return const CircularProgressIndicator();
        // }

        List<Result> posts = [];
        if(state is PostLoading) {
          posts = state.oldPost;
        }
        if(state is PostLoaded) {
          posts = state.posts;
        }

          return ListView.separated(shrinkWrap: true,
              controller: scrollController,
              itemBuilder: (context,index) {
                return ListTile(
                  title: Text(posts[index].name),
                  subtitle: Text(posts[index].url),
                );
          }, separatorBuilder: (context,index) => Divider(color: Colors.grey[400],), itemCount: posts.length);

       /* List<Result> posts = [];
        if(state is PostLoading) {
          posts = state.oldPost;
        }
        else if(state is PostLoaded) {
          posts = state.posts;
        }
        return ListView.separated(controller: scrollController,
            itemBuilder: (context,index) {
          if(index < posts.length) {
            return ListTile(
              title: Text(posts[index].name),
              subtitle: Text(posts[index].url),
            );
          }
          else {
            // Timer(const Duration(milliseconds: 10), () {
            //   scrollController.jumpTo(scrollController.position.maxScrollExtent);
            // });
            return const Center(child: CircularProgressIndicator(color: Colors.black,),);
          }
        }, separatorBuilder: (context,index) => Divider(color: Colors.grey[400],), itemCount: posts.length);*/




      },),
    ));
  }
}

