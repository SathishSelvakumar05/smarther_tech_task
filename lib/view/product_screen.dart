
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarther_tech_task/view/widget/product_card.dart';

import '../model/product_model.dart';
import '../viewmodel/product_cubit.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ProductCubit>().fetchAPI();
    super.initState();
  }

  List<Products> allProduct = [];
  List<Products> filterProduct = [];
  bool sortLowToHigh=false;

  final TextEditingController ctrl = TextEditingController();
  bool isSearch = false;

  void showBottomSheet(){
    showModalBottomSheet(context: context,
      builder: (context1) {
      return SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Sory by Price"),
        ),
        ListTile(
          onTap: (){
            sortLowToHigh=true;
            Navigator.pop(context1);
            reCalculate();
          },
          title: Text("Price :Low to High"),
          trailing: sortLowToHigh?Icon(Icons.check,color: Colors.green,):SizedBox(),
        ),
        ListTile(
          onTap: (){
            sortLowToHigh=false;
            Navigator.pop(context1);
            reCalculate();
          },
          title: Text("Price :High to Low"),
          trailing: !sortLowToHigh?Icon(Icons.check,color: Colors.green,):SizedBox(),
        ),

      ],));
    },);
  }
reCalculate(){
    final query=ctrl.text.trim().toLowerCase();
    List<Products>res=query.isEmpty?List<Products>.from(allProduct):allProduct.where((e){

      final title = (e.title ?? "").toLowerCase();
      final category = (e.category ?? "").toLowerCase();
      return title.contains(query)||category.contains(query);

    }).toList();
    if(sortLowToHigh==true){
      res.sort((a,b)=>price(a).compareTo(price(b)));
    }else if (sortLowToHigh==false){
      res.sort((a,b)=>price(b).compareTo(price(a)));

    }
    setState(() {
filterProduct=res;
    });
}
double price(Products p)=>(p.price is num)?(p.price as num).toDouble():0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearch) {
                  context.read<ProductCubit>().search("");
                }
                isSearch = !isSearch;
              });
            },
            icon: Icon(isSearch ? Icons.clear : Icons.search),
          ),
          IconButton(onPressed:
            showBottomSheet
          , icon:Icon(Icons.filter_alt_sharp))
        ],
        title: isSearch
            ? TextField(
                onChanged: (val) {
                  if (val.isEmpty) {
                    filterProduct = allProduct;
                  } else {
                    filterProduct = allProduct.where((e) {
                      final title = (e.title ?? "").toLowerCase();
                      final category = (e.category ?? "").toLowerCase();
                      return title.contains(val) || category.contains(val);
                    }).toList();
                  }
                  setState(() {});
                },
                controller: ctrl,
                decoration: InputDecoration(
                  hintText: "Search by",
                  border: InputBorder.none,
                ),
              )
            : Text("Dashboard Screen"),
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (c, s) {
          if (s is ProductSuccess) {
            allProduct = s.data.products ?? [];
            filterProduct = allProduct;
          }
        },
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProductFailure) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<ProductCubit>().fetchAPI();
                },
                child: Text(state.err),
              ),
            );
          }
          if (state is ProductSuccess) {
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: filterProduct.length ?? 0,
                itemBuilder: (context, index) {
                  final data = filterProduct![index];
                  return ProductCard(data: data);
                },
              ),
              onRefresh: () => context.read<ProductCubit>().fetchAPI(),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
