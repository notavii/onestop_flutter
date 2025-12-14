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


class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  int selectedTab = 0; // 0: For sale, 1: Requested Item
  // final TextEditingController _searchController = TextEditingController();

  // Sample data for demonstration
  final List<Map<String, dynamic>> ads = [
    {"name": "Product Name", "brandNew": true, "price": 40},
    {"name": "Product Name", "brandNew": false, "price": 40},
    {"name": "Product Name", "brandNew": false, "price": 40},
    {"name": "Product Name", "brandNew": true, "price": 40},
    {"name": "Product Name", "brandNew": false, "price": 40},
    {"name": "Product Name", "brandNew": false, "price": 40},
  ];


  final TextEditingController _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
            backgroundColor: OColor.white,
            title: Text(
              "My Ads",
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
          // Segmented Tabs
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
                content: "Search your ads",
              ),
          // Search Bar
          

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 12,
                childAspectRatio: .75,
              ),
              itemCount: ads.length,
              itemBuilder: (context, idx) {
                final ad = ads[idx];
                return _productCard(ad);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, int idx) {
    final selected = selectedTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.green.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.green : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> ad) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section (Placeholder)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ad["brandNew"] == true
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'BRAND NEW',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          // Details Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad["name"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "₹${ad["price"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.green, size: 18),
                    const SizedBox(width: 3),
                    Text(
                      "Edit",
                      style: TextStyle(color: Colors.green.shade700, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.delete, color: Colors.red, size: 18),
                    const SizedBox(width: 3),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.red.shade600, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


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
