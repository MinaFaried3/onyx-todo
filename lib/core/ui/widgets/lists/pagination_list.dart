// import 'package:speed_service/app/shared/common/common_libs.dart';
//
// class PaginatedListView<T> extends StatefulWidget {
//   final Widget Function(BuildContext context, T item, int index) itemBuilder;
//   final Widget Function(BuildContext context, int index)? separatorBuilder;
//   final Widget? Function()? handleRefresh;
//   final Widget? zeroItems;
//   final Widget? header;
//
//   const PaginatedListView({
//     super.key,
//     required this.itemBuilder,
//     this.separatorBuilder,
//     this.handleRefresh,
//     this.header,
//     this.zeroItems,
//   });
//
//   @override
//   State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
// }
//
// class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Add listener to fetch next page when reaching the bottom.
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
//     // Check if the user has scrolled near the bottom of the list.
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 100) {
//       // Fetch the next page when reaching the end of the list.
//       context.read<PaginatedCubit<T>>().fetchNextPage();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBlocConsumer<PaginatedCubit<T>, PaginatedState<T>>(
//       builder: (context, state) {
//         return RefreshIndicator(
//           onRefresh: () async {
//             await context.read<PaginatedCubit<T>>().refreshData();
//           },
//           child: state.uiState.maybeWhen(
//             loading: () => LoadingIndicator(),
//             orElse: () {
//               if (widget.zeroItems != null &&
//                   state.items.isEmpty &&
//                   state.uiState != UiState.loading &&
//                   state.uiState != UiState.initial) {
//                 return widget.zeroItems!;
//               }
//
//               return CustomScrollView(
//                 controller: _scrollController,
//                 slivers: [
//                   if (widget.header != null)
//                     SliverToBoxAdapter(child: widget.header),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         // Display each item using the provided itemBuilder.
//                         if (index < state.items.length) {
//                           final itemWidget = widget.itemBuilder(
//                               context, state.items[index], index);
//
//                           if (widget.separatorBuilder != null && index > 0) {
//                             return Column(
//                               crossAxisAlignment: .start,
//                               children: [
//                                 widget.separatorBuilder!(context, index - 1),
//                                 itemWidget,
//                               ],
//                             );
//                           }
//                           return itemWidget;
//                         }
//
//                         if (state.hasMore && state.uiState.isSucceed) {
//                           return const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 16.0),
//                             child: LoadingIndicator(),
//                           );
//                         }
//
//                         // Otherwise, return null for the end of the list.
//                         return null;
//                       },
//                       childCount: state.hasMore
//                           ? state.items.length + 1
//                           : state.items.length,
//                     ),
//                   ),
//                   if (state.items.isNotEmpty)
//                     const SliverToBoxAdapter(
//                       child: SizedBox(height: AppSize.s0_25),
//                     ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
