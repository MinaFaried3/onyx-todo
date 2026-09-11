// import 'package:speed_service/app/shared/common/common_libs.dart';
// import 'package:speed_service/presentation/modules/main/pages/home/cubit/home_cubit.dart';
//
// class PaginatedListViewTabs<T extends BaseService> extends StatefulWidget {
//   final Widget Function(BuildContext context, T item) itemBuilder;
//   final Widget? Function()? handleRefresh;
//   final Widget? header;
//   final List<String> tabs;
//   final Map<int, PaginatedCubit<T>> cubits; // A map of cubits for each tab
//   final List<Widget> zeroItems;
//
//   const PaginatedListViewTabs({
//     super.key,
//     required this.itemBuilder,
//     this.handleRefresh,
//     this.header,
//     required this.tabs,
//     required this.cubits,
//     required this.zeroItems,
//   });
//
//   @override
//   State<PaginatedListViewTabs<T>> createState() =>
//       _PaginatedListViewTabsState<T>();
// }
//
// class _PaginatedListViewTabsState<T extends BaseService>
//     extends State<PaginatedListViewTabs<T>> with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   late TabController _tabController;
//   late PaginatedCubit<T> _currentCubit;
//
//   defineTabController(LocalState? state) {
//     _tabController = TabController(
//         vsync: this,
//         length: state.isNull
//             ? widget.tabs.length
//             : (state!.showSubscription)
//                 ? 2
//                 : 1);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize with the first cubit
//     defineTabController(null);
//     _currentCubit = widget.cubits[_tabController.index]!;
//     _tabController.addListener(_onTabChanged);
//
//     // Add listener to fetch the next page when reaching the bottom.
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _tabController.removeListener(_onTabChanged);
//     _scrollController.dispose();
//     _tabController.dispose(); // Dispose the TabController
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         (_scrollController.position.maxScrollExtent)) {
//       _currentCubit.fetchNextPage();
//     }
//   }
//
//   void _onTabChanged() {
//     setState(() {});
//     // Update the current cubit based on the selected tab index
//     _currentCubit = widget.cubits[_tabController.index]!;
//     if (_currentCubit.state.items.isEmpty) {
//       _currentCubit.refreshData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _currentCubit,
//       child: AppBlocConsumer<PaginatedCubit<T>, PaginatedState<T>>(
//         builder: (context, state) {
//           return RefreshIndicator(
//             onRefresh: () async {
//               context.read<HomeCubit>().checkIfHaveNewNotification();
//               await _currentCubit.refreshData();
//               if (widget.handleRefresh != null) {
//                 widget.handleRefresh!();
//               }
//             },
//             child: _buildListView(state),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildListView(PaginatedState<T> state) {
//     return CustomScrollView(
//       controller: _scrollController,
//       slivers: [
//         // Optional header
//         if (widget.header != null) SliverToBoxAdapter(child: widget.header),
//         // SliverAppBar with TabBar
//         SliverAppBar(
//           toolbarHeight: AppSize.s60,
//           pinned: true,
//           primary: true,
//           automaticallyImplyLeading: false,
//           snap: true,
//           floating: true,
//           surfaceTintColor: ColorsManager.white,
//           title: Container(
//             padding: EdgeInsets.all(0),
//             decoration: BoxDecoration(
//               border: Border.all(color: ColorsManager.whiteBlueBgColor),
//               borderRadius: BorderRadius.circular(AppSize.s8),
//             ),
//             child: AppBlocConsumer<LocalCubit, LocalState>(
//               listener: (context, state) {
//                 refreshTabController(state);
//               },
//               builder: (context, state) {
//                 return TabBar(
//                   overlayColor:
//                       WidgetStatePropertyAll<Color>(ColorsManager.white),
//                   dividerColor: Colors.transparent,
//                   indicatorColor: Colors.transparent,
//                   controller: _tabController,
//                   labelColor: ColorsManager.white,
//                   unselectedLabelColor: ColorsManager.darkTextColor,
//                   labelPadding: EdgeInsets.all(AppSize.s8),
//                   labelStyle: get700BoldStyle(fontSize: AppSize.s16),
//                   tabAlignment: TabAlignment.fill,
//                   indicator: BoxDecoration(
//                     color: ColorsManager.bluePrimary,
//                     borderRadius: BorderRadius.circular(AppSize.s8),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     vertical: AppSize.s8,
//                     horizontal: AppSize.s8,
//                   ),
//                   unselectedLabelStyle: get700BoldStyle(
//                       color: ColorsManager.darkTextColor,
//                       fontSize: AppSize.s16),
//                   dividerHeight: 0,
//                   indicatorPadding: EdgeInsets.all(0),
//                   isScrollable: false,
//                   automaticIndicatorColorAdjustment: true,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   tabs: widget.tabs
//                       .map((item) => Center(
//                             child: FittedBox(
//                               child: Text(
//                                 item,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                 );
//               },
//             ),
//           ),
//         ),
//
//         /// Show the [zerItems] widget when the state is empty and UI is not loading
//         if (_currentCubit.state.items.isEmpty &&
//             (_currentCubit.state.uiState.isLoading.isFalse &&
//                 _currentCubit.state.uiState.isInitial.isFalse))
//           SliverPadding(
//             padding: EdgeInsets.all(8),
//             sliver: SliverToBoxAdapter(
//               child: widget.zeroItems[
//                   widget.tabs.indexOf(widget.tabs[_tabController.index])],
//             ),
//           ),
//
//         // Tab content managed through Slivers
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               if (index < _currentCubit.state.items.length) {
//                 // Otherwise, display the list of items
//                 return widget.itemBuilder(
//                     context, _currentCubit.state.items[index]);
//               }
//
//               if (_currentCubit.state.hasMore) {
//                 return const Padding(
//                   padding: EdgeInsets.symmetric(vertical: AppSize.s24),
//                   child: LoadingIndicator(),
//                 );
//               }
//
//               // Otherwise, return null for the end of the list.
//               return null;
//             },
//             // Adjust the item count depending on whether more data is available
//             childCount: _currentCubit.state.hasMore
//                 ? _currentCubit.state.items.length + 1
//                 : _currentCubit.state.items.length,
//           ),
//         ),
//
//         // Loading indicator when more items are available
//
//         // Add any additional spacing or footer
//         SliverToBoxAdapter(child: SizedBox(height: AppSize.s24)),
//       ],
//     );
//   }
//
//   void refreshTabController(LocalState? state) {
//     defineTabController(state);
//     _tabController.removeListener(_onTabChanged);
//     _tabController.addListener(_onTabChanged);
//   }
// }
