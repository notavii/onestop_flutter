import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/food/rest_frame_builder.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/utils/colors.dart';

import 'details_dialog.dart';

class BuyTile extends StatelessWidget {
  const BuyTile({
    super.key,
    required this.model,
  });

  final dynamic model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        detailsDialogBox(context, model);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration( 
            color: OColor.white,
            shape: RoundedRectangleBorder(
              side:  BorderSide(
                width: 1,
                color: OColor.gray200
                
              ),
              borderRadius: BorderRadius.circular(8)
            ),
            
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 171,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  clipBehavior: Clip.antiAlias,
                  decoration:  BoxDecoration(
                    color: OColor.gray100,
                    
                  ),


                  
                    
                    child: Image.network(
                    model.imageURL,
                    fit: BoxFit.cover,
                    cacheWidth: 300,
                    frameBuilder: restaurantTileFrameBuilder,
                    errorBuilder: (_, _, _) => Container(color: OColor.gray400),
                        ),
                    ),
                   
                 
                

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          model.title,
                          style: MyFonts.w500.size(14).setColor(OColor.gray800),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                              ),
                      const SizedBox(height: 4,),
                     
                            
                      Text(
                            '\u{20B9}${model.price}',
                              style: MyFonts.w500.size(16).setColor(OColor.gray800),
                              ),
                    ],
                  ),
              )
            ],
          ),
        ),
      );
  }
}
