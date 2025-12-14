import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/pages/lost_found/lnf_home.dart';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/stores/common_store.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/widgets/buy_sell/buy_tile.dart';
import 'package:onestop_dev/widgets/buy_sell/item_type_bar.dart';
import 'package:onestop_dev/widgets/lostfound/add_item_button.dart';
import 'package:onestop_dev/widgets/lostfound/ads_tile.dart';
import 'package:onestop_dev/widgets/mapbox/map_box.dart';
import 'package:onestop_dev/widgets/ui/list_shimmer.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';
import 'package:provider/provider.dart';
import 'myads_page.dart';



class BuySellHome extends StatefulWidget {
  static const id = "/buySellHome";
  const BuySellHome({super.key});
  @override
  State<BuySellHome> createState() => _BuySellHomeState();
}

class _BuySellHomeState extends State<BuySellHome> {
  final TextEditingController _searchcontroller = TextEditingController();
  final PagingController<int, BuyModel> _sellController = PagingController(
    fetchPage: (pageKey) {
      return BnsRepository().getSellPage(pageKey);
    },
    getNextPageKey: (state) {
      return state.lastPageIsEmpty ? null : state.nextIntPageKey;
    },
  );
  final PagingController<int, SellModel> _buyController = PagingController(
    fetchPage: (pageKey) {
      return BnsRepository().getBuyPage(pageKey);
    },
    getNextPageKey: (state) {
      return state.lastPageIsEmpty ? null : state.nextIntPageKey;
    },
  );
  void callSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Observer(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: OColor.white,
            title: Text(
              "Buy and Sell",
              style: TextStyle(
                fontFamily: "Geist",
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w500,
                color: OColor.gray800,
              ),
            ),
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: BackButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: const [SizedBox(width: 48)],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE9E9EA), height: 1),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ItemType2(
                        commonStore: commonStore,
                        title: "Sell",
                        label: "For Sale",
                      ),
                    ),
                    Expanded(
                      child: ItemType2(
                        commonStore: commonStore,
                        title: "Buy",
                        label: "Requested Item",
                      ),
                    ),
                  ],
                ),
              ),
              OSearchBar(
                controller: _searchcontroller,
                content: "Search Products",
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                   
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child:Text("$now"),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "All Ads",
                          style: OneStopStyles.basicFontStyle.setColor(kWhite),
                        ),
                      ),
                    ),
                    if (commonStore.bnsIndex == "Sell")
                      _listSellItems()
                    else if (commonStore.bnsIndex == "Buy")
                      _listBuyItems(),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: LoginStore().isGuestUser
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.only(right: 8, bottom: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AddItemButton(type: commonStore.bnsIndex),
                      const SizedBox(height: 6),
                      SecondaryButton(
                        label: "My Ads",
                        leadingIcon: FluentIcons.door_tag_20_filled,
                        bgColor: Colors.white,
                        labelStyle: const TextStyle(
                          color: Color(0xFF148440),
                          fontFamily: 'Geist',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        iconColor: Color(0xFF148440),
                        height: 58,
                        width: 132,
                        onPressed: () {
                          // Navigate to user's ads list page or show a filtered dialog
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyAdsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  PagingListener<int, SellModel> _listBuyItems() {
    return PagingListener(
      controller: _buyController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverGrid<int, SellModel>(
          state: state,
          fetchNextPage: fetchNextPage,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
            ),
            builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, buyItem, index) => BuyTile(model: buyItem),
            firstPageErrorIndicatorBuilder:
                (context) => ErrorReloadScreen(reloadCallback: () => _buyController.refresh()),
            noItemsFoundIndicatorBuilder:
                (context) => const PaginationText(text: "No items found"),
            newPageErrorIndicatorBuilder:
                (context) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: ErrorReloadButton(reloadCallback: () => _buyController.refresh()),
                    ),
            newPageProgressIndicatorBuilder:
                (context) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
            firstPageProgressIndicatorBuilder:
                (context) => ListShimmer(count: 5, height: 120),
            noMoreItemsIndicatorBuilder:
                (context) => const PaginationText(text: "You've reached the end"),
          
        )
        );
      },
    );
  }

  PagingListener<int, BuyModel> _listSellItems() {
    return PagingListener(
      controller: _sellController,
      builder: (context, state, fetchNextPage) {
        return PagedSliverGrid<int, BuyModel>(
          state: state,
          fetchNextPage: fetchNextPage,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, sellItem, index) => BuyTile(model: sellItem),
            firstPageErrorIndicatorBuilder:
                (context) => ErrorReloadScreen(reloadCallback: () => _sellController.refresh()),
            noItemsFoundIndicatorBuilder:
                (context) => const PaginationText(text: "No items found"),
            newPageErrorIndicatorBuilder:
                (context) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: ErrorReloadButton(reloadCallback: () => _sellController.refresh()),
                    ),
            newPageProgressIndicatorBuilder:
                (context) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
            firstPageProgressIndicatorBuilder:
                (context) => ListShimmer(count: 5, height: 120),
            noMoreItemsIndicatorBuilder:
                (context) => const PaginationText(text: "You've reached the end"),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _sellController.dispose();
    _buyController.dispose();
    super.dispose();
  }
}

// The ItemType2 widget code is unchanged; keep as-is.
class ItemType2 extends StatelessWidget {
  const ItemType2({
    super.key,
    required this.commonStore,
    required this.title,
    required this.label,
  });

  final CommonStore commonStore;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        commonStore.setBnsIndex(title);
      },
      child: Container(
        decoration: ShapeDecoration(
          color: commonStore.bnsIndex == title
              ? OColor.gray200
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: commonStore.bnsIndex == title
                    ? OColor.green600
                    : OColor.gray600, // Colors-Gray-600
                fontSize: 14,
                fontFamily: 'Geist',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
