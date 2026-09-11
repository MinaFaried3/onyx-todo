//
//
// import 'package:flutter/material.dart';
//
// class PaginatedHorizontalListView<T> extends StatefulWidget {
//   final Widget Function(T item, int index) itemBuilder;
//   final EdgeInsets? padding;
//   final double? separatorWidth;
//   final bool hasFooter;
//   final Widget zeroItems;
//
//   const PaginatedHorizontalListView({
//     super.key,
//     required this.itemBuilder,
//     this.padding,
//     this.separatorWidth,
//     this.hasFooter = false,
//     required this.zeroItems,
//   });
//
//   @override
//   State<PaginatedHorizontalListView<T>> createState() =>
//       _PaginatedHorizontalListViewState<T>();
// }
//
// class _PaginatedHorizontalListViewState<T>
//     extends State<PaginatedHorizontalListView<T>> {
//   late final ScrollController _scrollController;
//   late final ScrollController _scrollDotsController;
//   static final double _paginationThreshold = 200.w;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollDotsController = ScrollController();
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     double currentScrollOffset = _scrollController.position.pixels;
//     if (_scrollController.position.maxScrollExtent - currentScrollOffset <=
//         _paginationThreshold) {
//       context.read<PaginatedCubit<T>>().fetchNextPage();
//     }
//
//     double itemWidth = (widget.separatorWidth ?? 0) + _paginationThreshold;
//
//     int index = (currentScrollOffset / itemWidth).round();
//
//     /// check if cubit current index is still the same as scroll index
//     /// to avoid unneeded emits of states
//     if (index != context.read<PaginatedCubit<T>>().getCurrentIndex) {
//       /// check for current scroll position and animate to item position
//       double targetScrollPosition = (index * itemWidth);
//       if ((currentScrollOffset % itemWidth) != 0) {
//         _scrollController.animateTo(
//           targetScrollPosition,
//           duration: Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//         );
//       }
//
//       /// change current index in cubit
//       context.read<PaginatedCubit<T>>().setCurrentIndex(index);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBlocConsumer<PaginatedCubit<T>, PaginatedState<T>>(
//       builder: (context, state) {
//         return RefreshIndicator(
//           onRefresh: () async =>
//               await context.read<PaginatedCubit<T>>().refreshData(),
//           child: Column(
//             children: [
//               if (state.items.isEmpty) widget.zeroItems,
//               if (state.items.isNotEmpty)
//                 Expanded(
//                   child: CustomScrollView(
//                     controller: _scrollController,
//                     scrollDirection: .horizontal,
//                     slivers: [
//                       SliverToBoxAdapter(child: SizedBox(width: 12)),
//                       SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                           (ctx, index) {
//                             // Display each item using the provided itemBuilder.
//
//                             if (index < state.items.length) {
//                               return Row(
//                                 children: [
//                                   widget.itemBuilder(state.items[index], index),
//                                   HorizontalSpace(widget.separatorWidth ?? 0),
//                                 ],
//                               );
//                             }
//
//                             // Show a loading indicator at the bottom if there are more items to load.
//                             if (state.hasMore) {
//                               return Padding(
//                                 padding: widget.padding ??
//                                     EdgeInsets.symmetric(
//                                         horizontal: AppSize.s16),
//                                 child: LoadingIndicator(),
//                               );
//                             }
//
//                             // Otherwise, return null for the end of the list.
//                             return null;
//                           },
//                           childCount: state.hasMore
//                               ? state.items.length + 1
//                               : state.items.length,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               if (widget.hasFooter && state.items.isNotEmpty)
//                 VerticalSpace(AppSize.s10.sp),
//               if (widget.hasFooter && state.items.isNotEmpty)
//                 SingleChildScrollView(
//                   scrollDirection: .horizontal,
//                   child: SliderDotsWidget(
//                     items: state.items,
//                     selectedIndex:
//                         context.read<PaginatedCubit<T>>().getCurrentIndex,
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//       // builder: (context, state) {
//       //   AppLogger().debug("items length is ${state.items.length}");
//       //   return state.uiState.maybeWhenWidgets(
//       //     orElse: () => ListView.separated(
//       //       padding: widget.padding,
//       //       controller: _scrollController,
//       //       scrollDirection: .horizontal,
//       //       itemCount: state.items.length + (state.hasMore ? 1 : 0),
//       //       separatorBuilder: (context, index) =>
//       //           SizedBox(width: widget.separatorWidth ?? 8),
//       //       itemBuilder: (context, index) {
//       //         if (index == state.items.length) {
//       //           return LoadingIndicator();
//       //         }
//       //         return widget.itemBuilder(state.items[index]);
//       //       },
//       //     ),
//       //   );
//       // },
//     );
//   }
// }
