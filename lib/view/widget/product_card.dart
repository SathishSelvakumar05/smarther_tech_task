import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smarther_tech_task/model/product_model.dart';

class ProductCard extends StatefulWidget {
  final Products data;
  const ProductCard({super.key,required this.data});

  @override
  State<ProductCard> createState() => _ProductCardState();
}
bool isfav=false;
class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: Padding(padding: EdgeInsetsGeometry.all(2),child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: CachedNetworkImage(
              errorWidget: (context,url,e)=>Container(
                height: 80,width: 80,child: Icon(Icons.image),
              ),
              imageUrl: widget.data.images?.first??"",height: 80,width: 80,fit: BoxFit.contain,),

          ),
          SizedBox(width: 20,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.title??"",maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Text("Price : ${widget.data.price.toString()}"),
              SizedBox(height: 4,),
              Row(
                children: [
                  Icon(Icons.star,color: Colors.yellow,),
                  SizedBox(width: 2,),
                  Text(widget.data.rating.toString()),
                ],
              ),

            ],)),
          IconButton(onPressed: (){
            setState(() {
              isfav=!isfav;
            });
          }, icon: Icon(isfav?Icons.favorite:Icons.favorite_border))


        ],
      ),),
    );
  }
}
